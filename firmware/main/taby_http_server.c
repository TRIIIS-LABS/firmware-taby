#include "taby_http_server.h"

#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#include "cJSON.h"
#include "board_amoled_1_64.h"
#include "esp_check.h"
#include "esp_http_server.h"
#include "esp_log.h"
#include "esp_system.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "taby_build_info.h"
#include "taby_identity.h"
#include "taby_mqtt.h"
#include "taby_onboarding.h"
#include "taby_power.h"
#include "taby_reusable_preview.h"
#include "taby_reusable_ui.h"
#include "taby_runtime.h"
#include "taby_state_machine.h"
#include "taby_transport_prefs.h"
#include "taby_transport_protocol.h"
#include "taby_wifi.h"

static const char *TAG = "taby_http";
static httpd_handle_t s_server = NULL;

static const char *k_status_page_html =
    "<!doctype html>"
    "<html><head><meta charset='utf-8'>"
    "<meta name='viewport' content='width=device-width,initial-scale=1'>"
    "<meta http-equiv='Cache-Control' content='no-store, no-cache, must-revalidate, max-age=0'>"
    "<meta http-equiv='Pragma' content='no-cache'>"
    "<meta http-equiv='Expires' content='0'>"
    "<title>Taby</title>"
    "<style>"
    "body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;background:#0b0d11;color:#f7f7f5;}"
    ".wrap{min-height:100vh;display:grid;place-items:center;padding:24px;box-sizing:border-box;}"
    ".card{width:min(100%,440px);background:#141820;border:1px solid #2f3845;border-radius:24px;padding:24px;box-sizing:border-box;}"
    "h1{margin:0 0 10px;font-size:28px;line-height:1.05;}"
    "p{margin:0 0 18px;color:#b7bec8;font-size:15px;line-height:1.4;}"
    ".status-grid{display:grid;gap:10px;margin-top:18px;}"
    ".row{display:flex;justify-content:space-between;gap:16px;align-items:center;padding:14px 16px;border:1px solid #2f3845;border-radius:16px;background:#0d1117;}"
    ".label{font-size:12px;letter-spacing:.08em;text-transform:uppercase;color:#8f98a4;}"
    ".value{text-align:right;font-size:15px;color:#f7f7f5;}"
    ".actions{display:grid;gap:10px;margin-top:18px;}"
    ".button{display:block;width:100%;box-sizing:border-box;border:none;border-radius:18px;padding:15px 18px;background:#f3f4ee;color:#101317;font-size:16px;font-weight:700;text-align:center;text-decoration:none;}"
    ".button.secondary{background:#212833;color:#f7f7f5;font-weight:600;}"
    ".hint{margin-top:14px;font-size:12px;color:#8f98a4;text-align:center;}"
    "</style></head>"
    "<body><div class='wrap'><main class='card'>"
    "<h1>Taby is online</h1>"
    "<p>Use this page for local status. Open Wi-Fi setup only when you want to add or change networks.</p>"
    "<div class='status-grid'>"
    "<div class='row'><div class='label'>Current state</div><div id='state' class='value'>Loading…</div></div>"
    "<div class='row'><div class='label'>Wi-Fi</div><div id='wifi' class='value'>Loading…</div></div>"
    "<div class='row'><div class='label'>Power</div><div id='power' class='value'>Loading…</div></div>"
    "<div class='row'><div class='label'>Firmware</div><div id='firmware' class='value'>Loading…</div></div>"
    "<div class='row'><div class='label'>Device ID</div><div id='deviceId' class='value'>Loading…</div></div>"
    "</div>"
    "<div class='actions'>"
    "<a class='button secondary' href='/setup'>Manage Wi-Fi</a>"
    "</div>"
    "<div class='hint'>Battery and richer device details can be added here later without changing the setup flow.</div>"
    "</main></div>"
    "<script>"
    "async function loadStatus(){"
    "try{"
    "const response=await fetch('/v1/health',{cache:'no-store'});"
    "const data=await response.json();"
    "document.getElementById('state').textContent=data.state||'Unknown';"
    "document.getElementById('firmware').textContent=data.firmware_version||'Unknown';"
    "document.getElementById('deviceId').textContent=data.device_id||'Unknown';"
    "if(data.connected&&data.station_ssid){document.getElementById('wifi').textContent=`Connected to ${data.station_ssid}`;}"
    "else if(data.station_ssid){document.getElementById('wifi').textContent=`Saved: ${data.station_ssid}`;}"
    "else if(data.wifi_mode==='setup_ap'&&data.setup_ap_ssid){document.getElementById('wifi').textContent=`Setup AP: ${data.setup_ap_ssid}`;}"
    "else{document.getElementById('wifi').textContent='Not connected';}"
    "if(data.external_power&&data.power_voltage_mv>0){document.getElementById('power').textContent=`USB power · ${(data.power_voltage_mv/1000).toFixed(2)}V`;}"
    "else if(data.battery_percent>=0&&data.power_voltage_mv>0){document.getElementById('power').textContent=`Battery ${data.battery_percent}% · ${(data.power_voltage_mv/1000).toFixed(2)}V`;}"
    "else if(data.power_voltage_mv>0){document.getElementById('power').textContent=`Power ${(data.power_voltage_mv/1000).toFixed(2)}V`;}"
    "else{document.getElementById('power').textContent='Unavailable';}"
    "}catch(_err){"
    "document.getElementById('state').textContent='Unavailable';"
    "document.getElementById('wifi').textContent='Unavailable';"
    "document.getElementById('power').textContent='Unavailable';"
    "document.getElementById('firmware').textContent='Unavailable';"
    "document.getElementById('deviceId').textContent='Unavailable';"
    "}"
    "}"
    "loadStatus();"
    "setInterval(loadStatus,30000);"
    "</script>"
    "</body></html>";

static const char *k_setup_page_html =
    "<!doctype html>"
    "<html><head><meta charset='utf-8'>"
    "<meta name='viewport' content='width=device-width,initial-scale=1'>"
    "<meta http-equiv='Cache-Control' content='no-store, no-cache, must-revalidate, max-age=0'>"
    "<meta http-equiv='Pragma' content='no-cache'>"
    "<meta http-equiv='Expires' content='0'>"
    "<title>Set up Taby</title>"
    "<style>"
    "body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;background:#0b0d11;color:#f7f7f5;}"
    ".wrap{min-height:100vh;display:grid;place-items:center;padding:24px;box-sizing:border-box;}"
    ".card{width:min(100%%,440px);background:#141820;border:1px solid #2f3845;border-radius:24px;padding:24px;box-sizing:border-box;}"
    "h1{margin:0 0 10px;font-size:28px;line-height:1.05;}"
    "p{margin:0 0 18px;color:#b7bec8;font-size:15px;line-height:1.4;}"
    "label{display:grid;gap:8px;margin:14px 0 0;font-size:13px;color:#d9dee5;}"
    "input{width:100%%;box-sizing:border-box;border:none;border-radius:16px;padding:14px 16px;font-size:16px;background:#0d1117;color:#fff;outline:none;}"
    "button{margin-top:18px;width:100%%;border:none;border-radius:18px;padding:15px 18px;background:#f3f4ee;color:#101317;font-size:16px;font-weight:700;}"
    ".section-title{margin:20px 0 10px;font-size:12px;letter-spacing:.08em;text-transform:uppercase;color:#8f98a4;}"
    ".networks{display:grid;gap:10px;}"
    ".network{display:flex;justify-content:space-between;align-items:center;width:100%%;box-sizing:border-box;border:1px solid #2f3845;border-radius:16px;padding:12px 14px;background:#0d1117;color:#fff;font-size:15px;}"
    ".network small{color:#8f98a4;font-size:12px;}"
    ".secondary{margin-top:10px;background:#212833;color:#f7f7f5;font-weight:600;}"
    ".hint{margin-top:14px;font-size:12px;color:#8f98a4;text-align:center;}"
    ".hint.error{color:#ff7a72;}"
    ".toggle-row{display:flex;align-items:center;gap:14px;width:100%;box-sizing:border-box;margin-top:12px;padding:14px 16px;border:1px solid #2f3845;border-radius:16px;background:#0d1117;font-size:16px;font-weight:600;color:#f7f7f5;-webkit-tap-highlight-color:transparent;touch-action:manipulation;user-select:none;}"
    ".toggle-row span{flex:1;}"
    ".toggle-row input{width:24px;height:24px;padding:0;margin:0;accent-color:#f3f4ee;flex:0 0 auto;}"
    ".result{display:grid;place-items:center;gap:16px;min-height:360px;text-align:center;}"
    ".result-badge{padding:10px 16px;border-radius:999px;background:#173825;color:#91f0ac;font-size:12px;font-weight:700;letter-spacing:.14em;text-transform:uppercase;}"
    ".result-badge.pending{background:#1b2b44;color:#a6d0ff;}"
    ".result-title{margin:0;font-size:38px;line-height:.98;letter-spacing:-0.03em;}"
    ".result-copy{margin:0;max-width:280px;color:#d4dde7;font-size:18px;line-height:1.4;}"
    ".hidden{display:none;}"
    "</style></head>"
    "<body><div class='wrap'><main class='card'>"
    "<h1>Set up Taby</h1>"
    "<p>Enter the Wi-Fi Taby should join next.</p>"
    "<div id='setupContent'>"
    "<div class='section-title'>Nearby networks</div>"
    "<div id='nearby' class='networks'><div class='network'><span>Scanning nearby Wi-Fi…</span></div></div>"
    "<button type='button' id='showMoreNetworks' class='secondary hidden'>See more networks</button>"
    "<form id='setupForm'>"
    "<label>Wi-Fi name<input name='ssid' autocomplete='ssid' autocapitalize='none' required></label>"
    "<label>Password<input id='passwordInput' name='password' type='password' autocomplete='current-password'></label>"
    "<label class='toggle-row'><input id='showPassword' type='checkbox'><span>Show password</span></label>"
    "<button id='submitButton' type='submit'>Connect Taby</button>"
    "</form>"
    "<button type='button' id='rescan' class='secondary'>Scan again</button>"
    "<div id='statusHint' class='hint'>Stay on Taby Wi-Fi, then open 192.168.4.1 in Safari or Chrome.</div>"
    "</div>"
    "<section id='resultCard' class='result hidden'>"
    "<div id='resultBadge' class='result-badge'>Finished</div>"
    "<h2 id='resultTitle' class='result-title'>Return to Taby</h2>"
    "<p id='resultCopy' class='result-copy'>Taby connected successfully.</p>"
    "</section>"
    "</main></div>"
    "<script>"
    "const nearby=document.getElementById('nearby');"
    "const setupForm=document.getElementById('setupForm');"
    "const setupContent=document.getElementById('setupContent');"
    "const showMoreNetworks=document.getElementById('showMoreNetworks');"
    "const ssidInput=document.querySelector('input[name=\"ssid\"]');"
    "const passwordInput=document.getElementById('passwordInput');"
    "const showPassword=document.getElementById('showPassword');"
    "const submitButton=document.getElementById('submitButton');"
    "const statusHint=document.getElementById('statusHint');"
    "const resultCard=document.getElementById('resultCard');"
    "const resultBadge=document.getElementById('resultBadge');"
    "const resultTitle=document.getElementById('resultTitle');"
    "const resultCopy=document.getElementById('resultCopy');"
    "let setupPollTimer=null;"
    "let setupDeadlineTimer=null;"
    "let setupPollCount=0;"
    "let nearbyNetworks=[];"
    "let showingAllNearby=false;"
    "function pickNetwork(ssid){ssidInput.value=ssid;ssidInput.focus();}"
    "function networkLabel(network){const lock=network.secure?'Locked':'Open';return `${network.rssi} dBm · ${lock}`;}"
    "function displayedNetworks(){"
    "if(showingAllNearby){return nearbyNetworks;}"
    "const strong=nearbyNetworks.filter(network=>network.rssi>=-86);"
    "const recommended=(strong.length?strong:nearbyNetworks).slice(0,6);"
    "return recommended;"
    "}"
    "function renderNetworks(networks){"
    "nearbyNetworks=Array.isArray(networks)?networks:[];"
    "const visibleNetworks=displayedNetworks();"
    "if(!visibleNetworks.length){nearby.innerHTML=\"<div class='network'><span>No nearby Wi-Fi found yet</span><small>Enter it manually below</small></div>\";showMoreNetworks.classList.add('hidden');return;}"
    "nearby.innerHTML='';"
    "visibleNetworks.forEach(n=>{"
    "const button=document.createElement('button');button.type='button';button.className='network';button.addEventListener('click',()=>pickNetwork(n.ssid));"
    "const name=document.createElement('span');name.textContent=n.ssid;"
    "const meta=document.createElement('small');meta.textContent=networkLabel(n);"
    "button.appendChild(name);button.appendChild(meta);nearby.appendChild(button);"
    "});"
    "const hiddenCount=Math.max(0,nearbyNetworks.length-visibleNetworks.length);"
    "if(hiddenCount>0){showMoreNetworks.classList.remove('hidden');showMoreNetworks.textContent=showingAllNearby?'Show recommended only':`See ${hiddenCount} more network${hiddenCount===1?'':'s'}`;}else{showMoreNetworks.classList.add('hidden');}"
    "}"
    "async function loadNearby(){"
    "showingAllNearby=false;"
    "nearby.innerHTML=\"<div class='network'><span>Scanning nearby Wi-Fi…</span></div>\";"
    "showMoreNetworks.classList.add('hidden');"
    "try{const response=await fetch('/v1/wifi/nearby',{cache:'no-store'});const data=await response.json();renderNetworks(data.networks||[]);}catch(_err){nearby.innerHTML=\"<div class='network'><span>Could not scan nearby Wi-Fi</span><small>Enter it manually below</small></div>\";}"
    "}"
    "async function loadSetupStatus(){"
    "try{const response=await fetch('/v1/provisioning/info',{cache:'no-store'});const data=await response.json();"
    "if(data.wifi_error){statusHint.classList.add('error');statusHint.textContent=`Last attempt failed: ${data.wifi_error}. Check the password and try again.`;}"
    "}catch(_err){}"
    "}"
    "function showResult(kind,title,copy){"
    "setupContent.classList.add('hidden');"
    "resultCard.classList.remove('hidden');"
    "resultBadge.className='result-badge'+(kind==='pending'?' pending':'');"
    "resultBadge.textContent=kind==='pending'?'Switching':'Finished';"
    "resultTitle.textContent=title;"
    "resultCopy.textContent=copy;"
    "}"
    "function syncPasswordVisibility(){"
    "const show=!!showPassword.checked;"
    "passwordInput.type=show?'text':'password';"
    "}"
    "function clearSetupTimers(){"
    "if(setupPollTimer){clearInterval(setupPollTimer);setupPollTimer=null;}"
    "if(setupDeadlineTimer){clearTimeout(setupDeadlineTimer);setupDeadlineTimer=null;}"
    "}"
    "async function pollSetupProgress(){"
    "try{"
    "const response=await fetch('/v1/setup/status',{cache:'no-store'});"
    "const data=await response.json();"
    "setupPollCount+=1;"
    "if(data.transport_onboarding_complete||data.connected){"
    "clearSetupTimers();"
    "submitButton.disabled=true;"
    "submitButton.textContent='Connected';"
    "showResult('success','Return to Taby',data.station_ssid?`Taby connected to ${data.station_ssid}. You can return to the app now.`:'Taby connected successfully. You can return to the app now.');"
    "return;"
    "}"
    "if(data.wifi_error){"
    "clearSetupTimers();"
    "submitButton.disabled=false;"
    "submitButton.textContent='Connect Taby';"
    "statusHint.classList.add('error');"
    "statusHint.textContent=`Could not connect: ${data.wifi_error}. Check the password and try again.`;"
    "passwordInput.focus();"
    "}"
    "}catch(_error){"
    "if(setupPollCount>=2){"
    "clearSetupTimers();"
    "submitButton.disabled=true;"
    "submitButton.textContent='Connected';"
    "showResult('pending','Almost there','Taby is switching networks. If you see the idle animation, setup succeeded. Return to the app.');"
    "}"
    "}"
    "}"
    "async function submitSetup(event){"
    "event.preventDefault();"
    "const ssid=ssidInput.value.trim();"
    "const password=passwordInput.value;"
    "if(!ssid){statusHint.classList.add('error');statusHint.textContent='Enter the Wi-Fi name first.';ssidInput.focus();return;}"
    "submitButton.disabled=true;"
    "submitButton.textContent='Connecting…';"
    "statusHint.classList.remove('error');"
    "statusHint.textContent='Taby saved your Wi-Fi and is trying to connect now. If it returns to setup, open 192.168.4.1 and try again.';"
    "try{"
    "const response=await fetch('/v1/provision',{method:'POST',headers:{'Content-Type':'application/json'},cache:'no-store',body:JSON.stringify({ssid,password})});"
    "const data=await response.json().catch(()=>({}));"
    "if(!response.ok||data.ok===false){throw new Error(data.error||'Could not save Wi-Fi. Try again.');}"
    "clearSetupTimers();"
    "setupPollCount=0;"
    "setupPollTimer=setInterval(pollSetupProgress,700);"
    "setupDeadlineTimer=setTimeout(()=>{if(setupPollTimer){clearSetupTimers();submitButton.disabled=false;submitButton.textContent='Connect Taby';statusHint.classList.add('error');statusHint.textContent='Taby did not finish connecting. Check the password and try again.';}},25000);"
    "}catch(error){"
    "clearSetupTimers();"
    "submitButton.disabled=false;"
    "submitButton.textContent='Connect Taby';"
    "statusHint.classList.add('error');"
    "statusHint.textContent=(error&&error.message)?error.message:'Could not save Wi-Fi. Try again.';"
    "}"
    "}"
    "showPassword.addEventListener('change',syncPasswordVisibility);"
    "setupForm.addEventListener('submit',submitSetup);"
    "showMoreNetworks.addEventListener('click',()=>{showingAllNearby=!showingAllNearby;renderNetworks(nearbyNetworks);});"
    "document.getElementById('rescan').addEventListener('click',loadNearby);"
    "loadNearby();"
    "loadSetupStatus();"
    "</script>"
    "</body></html>";

static void delayed_restart_task(void *arg) {
    (void)arg;
    vTaskDelay(pdMS_TO_TICKS(400));
    esp_restart();
}

static void delayed_wifi_connect_task(void *arg) {
    (void)arg;
    vTaskDelay(pdMS_TO_TICKS(250));
    esp_err_t err = taby_wifi_connect_saved_networks();
    if (err != ESP_OK) {
        ESP_LOGW(TAG, "saved wifi connect failed: %s", esp_err_to_name(err));
    }
    vTaskDelete(NULL);
}

static esp_err_t send_json(httpd_req_t *req, const char *status, const char *body) {
    httpd_resp_set_status(req, status);
    httpd_resp_set_type(req, "application/json");
    httpd_resp_set_hdr(req, "Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
    httpd_resp_set_hdr(req, "Pragma", "no-cache");
    httpd_resp_set_hdr(req, "Expires", "0");
    return httpd_resp_sendstr(req, body);
}

static esp_err_t send_html(httpd_req_t *req, const char *status, const char *body) {
    httpd_resp_set_status(req, status);
    httpd_resp_set_type(req, "text/html; charset=utf-8");
    httpd_resp_set_hdr(req, "Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
    httpd_resp_set_hdr(req, "Pragma", "no-cache");
    httpd_resp_set_hdr(req, "Expires", "0");
    return httpd_resp_sendstr(req, body);
}

static void url_decode_in_place(char *value) {
    if (!value) {
        return;
    }

    char *read = value;
    char *write = value;
    while (*read != '\0') {
        if (*read == '+') {
            *write++ = ' ';
            read++;
            continue;
        }

        if (*read == '%' && read[1] != '\0' && read[2] != '\0') {
            char hi = read[1];
            char lo = read[2];
            int hi_val = (hi >= '0' && hi <= '9') ? hi - '0'
                : (hi >= 'A' && hi <= 'F') ? hi - 'A' + 10
                : (hi >= 'a' && hi <= 'f') ? hi - 'a' + 10
                : -1;
            int lo_val = (lo >= '0' && lo <= '9') ? lo - '0'
                : (lo >= 'A' && lo <= 'F') ? lo - 'A' + 10
                : (lo >= 'a' && lo <= 'f') ? lo - 'a' + 10
                : -1;
            if (hi_val >= 0 && lo_val >= 0) {
                *write++ = (char)((hi_val << 4) | lo_val);
                read += 3;
                continue;
            }
        }

        *write++ = *read++;
    }

    *write = '\0';
}

static bool read_form_field(const char *body, const char *key, char *out_value, size_t out_size) {
    if (!body || !key || !out_value || out_size == 0) {
        return false;
    }

    char query[384];
    size_t body_len = strlen(body);
    if (body_len >= sizeof(query)) {
        return false;
    }
    memcpy(query, body, body_len + 1);

    if (httpd_query_key_value(query, key, out_value, out_size) != ESP_OK) {
        return false;
    }

    url_decode_in_place(out_value);
    return out_value[0] != '\0';
}

static cJSON *parse_json_body(httpd_req_t *req, char *buffer, size_t buffer_size) {
    if (req->content_len <= 0 || (size_t)req->content_len >= buffer_size) {
        return NULL;
    }

    int received = httpd_req_recv(req, buffer, req->content_len);
    if (received <= 0) {
        return NULL;
    }

    buffer[received] = '\0';
    return cJSON_Parse(buffer);
}

static cJSON *build_wifi_networks_array(void) {
    taby_wifi_profile_t profiles[TABY_WIFI_MAX_PROFILES] = {0};
    size_t profile_count = 0;
    if (taby_wifi_get_profiles(profiles, TABY_WIFI_MAX_PROFILES, &profile_count) != ESP_OK) {
        return cJSON_CreateArray();
    }

    cJSON *array = cJSON_CreateArray();
    for (size_t i = 0; i < profile_count; ++i) {
        const taby_wifi_profile_t *profile = &profiles[i];
        cJSON *entry = cJSON_CreateObject();
        cJSON_AddStringToObject(entry, "ssid", profile->ssid);
        cJSON_AddStringToObject(entry, "label", profile->label);
        cJSON_AddNumberToObject(entry, "priority", profile->priority);
        cJSON_AddBoolToObject(entry, "auto_join", profile->auto_join);
        cJSON_AddBoolToObject(entry, "preferred", profile->preferred);
        cJSON_AddBoolToObject(entry, "last_success", profile->last_success);
        cJSON_AddItemToArray(array, entry);
    }
    return array;
}

static cJSON *build_nearby_networks_array(void) {
    taby_wifi_nearby_network_t networks[16] = {0};
    size_t network_count = 0;
    if (taby_wifi_scan_nearby_networks(networks, 16, &network_count) != ESP_OK) {
        return cJSON_CreateArray();
    }

    cJSON *array = cJSON_CreateArray();
    for (size_t i = 0; i < network_count; ++i) {
        cJSON *entry = cJSON_CreateObject();
        cJSON_AddStringToObject(entry, "ssid", networks[i].ssid);
        cJSON_AddNumberToObject(entry, "rssi", networks[i].rssi);
        cJSON_AddBoolToObject(entry, "secure", networks[i].secure);
        cJSON_AddItemToArray(array, entry);
    }
    return array;
}

static cJSON *build_setup_info_json(void) {
    const taby_identity_t *identity = taby_identity_get();
    taby_wifi_setup_info_t setup_info = {0};
    taby_wifi_get_setup_info(&setup_info);

    cJSON *root = cJSON_CreateObject();
    cJSON_AddStringToObject(root, "device_id", identity ? identity->device_id : "");
    cJSON_AddStringToObject(root, "wifi_mode", taby_wifi_mode_name());
    cJSON_AddBoolToObject(root, "provisioned", taby_wifi_is_provisioned());
    cJSON_AddBoolToObject(root, "connected", taby_wifi_is_connected());
    cJSON_AddStringToObject(root, "station_ssid", taby_wifi_station_ssid() ? taby_wifi_station_ssid() : "");
    cJSON_AddStringToObject(root, "wifi_error", taby_wifi_last_error() ? taby_wifi_last_error() : "");
    cJSON_AddBoolToObject(root, "transport_onboarding_complete", taby_transport_onboarding_complete());
    cJSON_AddStringToObject(root, "preferred_transport", taby_transport_preferred_mode_name());

    cJSON *setup_ap = cJSON_CreateObject();
    cJSON_AddStringToObject(setup_ap, "ssid", setup_info.ssid);
    cJSON_AddStringToObject(setup_ap, "password", setup_info.password);
    cJSON_AddStringToObject(setup_ap, "host", setup_info.host);
    cJSON_AddStringToObject(setup_ap, "qr_payload", setup_info.qr_payload);
    cJSON_AddItemToObject(root, "setup_ap", setup_ap);
    cJSON_AddItemToObject(root, "saved_networks", build_wifi_networks_array());
    return root;
}

static esp_err_t ping_handler(httpd_req_t *req) {
    httpd_resp_set_type(req, "text/plain");
    return httpd_resp_sendstr(req, "!");
}

static esp_err_t state_handler(httpd_req_t *req) {
    httpd_resp_set_type(req, "text/plain");
    return httpd_resp_sendstr(req, taby_transport_state_name(taby_runtime_current_state()));
}

static esp_err_t touch_handler(httpd_req_t *req) {
    httpd_resp_set_type(req, "text/plain");
    char body[24];
    snprintf(body, sizeof(body), "%u", (unsigned int)board_amoled_1_64_touch_signal());
    return httpd_resp_sendstr(req, body);
}

static esp_err_t reusable_choice_signal_handler(httpd_req_t *req) {
    taby_reusable_choice_signal_t signal = {0};
    taby_reusable_ui_read_choice_signal(&signal);

    char response[96];
    snprintf(
        response,
        sizeof(response),
        "{\"signal\":%u,\"selection\":\"%s\"}",
        (unsigned int)signal.signal,
        taby_reusable_ui_choice_selection_name(signal.selection));
    return send_json(req, "200 OK", response);
}

static const char *reusable_ui_command_from_command(const char *text) {
    if (!text) {
        return NULL;
    }

    return strncmp(text, "UI/", 3) == 0 ? text : NULL;
}

static cJSON *build_display_orientation_json(bool include_imu_diagnostics) {
    cJSON *root = cJSON_CreateObject();
    if (!root) {
        return NULL;
    }

    taby_display_orientation_status_t status = {0};
    board_amoled_1_64_display_orientation_status(&status);
    cJSON_AddStringToObject(root, "mode", status.mode_name);
    cJSON_AddStringToObject(root, "orientation", status.orientation_name);
    cJSON_AddNumberToObject(root, "rotation_degrees", status.rotation_degrees);
    cJSON_AddBoolToObject(root, "auto_supported", status.auto_supported);

    if (include_imu_diagnostics) {
        taby_orientation_imu_diagnostics_t imu = {0};
        board_amoled_1_64_orientation_imu_diagnostics(&imu);
        cJSON_AddBoolToObject(root, "imu_available", imu.available);
        cJSON_AddNumberToObject(root, "imu_who_am_i", imu.who_am_i);
        cJSON_AddNumberToObject(root, "imu_revision_id", imu.revision_id);
        cJSON_AddNumberToObject(root, "imu_accel_x_raw", imu.accel_x_raw);
        cJSON_AddNumberToObject(root, "imu_accel_y_raw", imu.accel_y_raw);
        cJSON_AddNumberToObject(root, "imu_accel_z_raw", imu.accel_z_raw);
        cJSON_AddNumberToObject(root, "imu_accel_x_mg", imu.accel_x_mg);
        cJSON_AddNumberToObject(root, "imu_accel_y_mg", imu.accel_y_mg);
        cJSON_AddNumberToObject(root, "imu_accel_z_mg", imu.accel_z_mg);
        cJSON_AddNumberToObject(
            root,
            "imu_sample_age_ms",
            imu.sample_age_ms == UINT32_MAX ? -1 : (double)imu.sample_age_ms);
        cJSON_AddNumberToObject(root, "imu_sample_count", imu.sample_count);
        cJSON_AddNumberToObject(root, "imu_read_error_count", imu.read_error_count);
        cJSON_AddStringToObject(
            root,
            "auto_candidate",
            imu.candidate_valid
                ? (imu.candidate == TABY_DISPLAY_ORIENTATION_RIGHT ? "right" : "left")
                : "");
        cJSON_AddNumberToObject(root, "auto_stable_ms", imu.stable_ms);
        cJSON_AddNumberToObject(root, "auto_confidence_percent", imu.confidence_percent);
        cJSON_AddStringToObject(
            root,
            "auto_state",
            board_amoled_1_64_orientation_imu_state_name(imu.state));
    }

    return root;
}

static esp_err_t send_display_orientation_json(httpd_req_t *req, bool include_imu_diagnostics) {
    cJSON *root = build_display_orientation_json(include_imu_diagnostics);
    if (!root) {
        return send_json(req, "500 Internal Server Error", "{\"ok\":false,\"error\":\"encode failed\"}");
    }
    cJSON_AddBoolToObject(root, "ok", true);
    char *body = cJSON_PrintUnformatted(root);
    cJSON_Delete(root);
    if (!body) {
        return send_json(req, "500 Internal Server Error", "{\"ok\":false,\"error\":\"encode failed\"}");
    }
    esp_err_t result = send_json(req, "200 OK", body);
    cJSON_free(body);
    return result;
}

static bool parse_display_orientation_command(
    const char *text,
    bool *is_query,
    taby_display_orientation_mode_t *mode) {
    if (!text) {
        return false;
    }

    if (strcmp(text, "DISPLAY_ORIENTATION") == 0 ||
        strcmp(text, "DISPLAY_ORIENTATION?") == 0) {
        if (is_query) {
            *is_query = true;
        }
        return true;
    }

    if (strncmp(text, "DISPLAY_ORIENTATION ", 20) != 0) {
        return false;
    }

    if (is_query) {
        *is_query = false;
    }
    return board_amoled_1_64_parse_display_orientation_mode(text + 20, mode);
}

static esp_err_t apply_display_orientation_http_command(
    httpd_req_t *req,
    bool is_query,
    taby_display_orientation_mode_t mode) {
    if (!is_query) {
        if (mode == TABY_DISPLAY_ORIENTATION_MODE_AUTO &&
            !board_amoled_1_64_display_orientation_auto_supported()) {
            return send_json(
                req,
                "400 Bad Request",
                "{\"ok\":false,\"error\":\"auto orientation unsupported\"}");
        }
        if (!taby_runtime_set_display_orientation_mode(mode)) {
            return send_json(
                req,
                "500 Internal Server Error",
                "{\"ok\":false,\"error\":\"orientation failed\"}");
        }
    }
    return send_display_orientation_json(req, true);
}

static esp_err_t compat_command_handler(httpd_req_t *req) {
    char query[192] = {0};
    char command_buffer[2048] = {0};
    if (httpd_req_get_url_query_str(req, query, sizeof(query)) != ESP_OK) {
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"missing query\"}");
    }

    if (httpd_query_key_value(query, "c", command_buffer, sizeof(command_buffer)) != ESP_OK &&
        httpd_query_key_value(query, "name", command_buffer, sizeof(command_buffer)) != ESP_OK &&
        httpd_query_key_value(query, "command", command_buffer, sizeof(command_buffer)) != ESP_OK) {
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"missing command\"}");
    }

    bool orientation_query = false;
    taby_display_orientation_mode_t orientation_mode = TABY_DISPLAY_ORIENTATION_MODE_LEFT;
    if (parse_display_orientation_command(
            command_buffer,
            &orientation_query,
            &orientation_mode)) {
        return apply_display_orientation_http_command(
            req,
            orientation_query,
            orientation_mode);
    }

    const char *reusable_ui_command = reusable_ui_command_from_command(command_buffer);
    if (reusable_ui_command) {
        char ui_error[96] = {0};
        if (!taby_reusable_preview_render_ui_command(reusable_ui_command, ui_error, sizeof(ui_error))) {
            char body[160];
            snprintf(
                body,
                sizeof(body),
                "{\"ok\":false,\"error\":\"%s\"}",
                ui_error[0] ? ui_error : "ui render failed");
            return send_json(req, "400 Bad Request", body);
        }

        taby_mqtt_notify_state_changed("http_ui_command");
        return send_json(req, "200 OK", "{\"ok\":true,\"accepted\":true}");
    }

    taby_transport_resolution_t resolution = {0};
    if (!taby_transport_resolve_text(command_buffer, &resolution)) {
        ESP_LOGW(TAG, "unsupported compatibility command: %s", command_buffer);
        return send_json(req, "202 Accepted", "{\"ok\":true,\"accepted\":false}");
    }

    taby_runtime_apply_transport_resolution(&resolution);
    taby_mqtt_notify_state_changed("http_compat_command");
    ESP_LOGI(TAG, "compat command applied raw=%s mapped=%s", command_buffer, taby_state_name(taby_runtime_current_state()));
    return send_json(req, "200 OK", "{\"ok\":true,\"accepted\":true}");
}

static esp_err_t health_handler(httpd_req_t *req) {
    const taby_identity_t *identity = taby_identity_get();
    taby_power_status_t power = taby_power_get_status();
    taby_display_orientation_status_t orientation = {0};
    board_amoled_1_64_display_orientation_status(&orientation);
    char body[1280];
    snprintf(body,
             sizeof(body),
             "{\"firmware_version\":\"%s\",\"assets_version\":\"%s\",\"hardware_target\":\"%s\",\"display_shape\":\"%s\",\"display_width\":%u,\"display_height\":%u,\"device_id\":\"%s\",\"claimed\":%s,\"claimed_by\":\"%s\",\"wifi_mode\":\"%s\",\"connected\":%s,"
             "\"ip\":\"%s\",\"mdns_host\":\"%s\",\"station_ssid\":\"%s\",\"setup_ap_ssid\":\"%s\",\"state\":\"%s\",\"wifi_error\":\"%s\","
             "\"transport_onboarding_complete\":%s,\"preferred_transport\":\"%s\","
             "\"power_voltage_mv\":%d,\"battery_percent\":%d,\"external_power\":%s,"
             "\"mqtt_enabled\":%s,\"mqtt_connected\":%s,\"mqtt_broker\":\"%s\","
             "\"display_orientation_mode\":\"%s\",\"display_orientation\":\"%s\",\"display_rotation_degrees\":%u,\"display_orientation_auto_supported\":%s,"
             "\"identity_source\":\"%s\",\"has_factory_data\":%s}",
             taby_firmware_version(),
             taby_assets_version(),
             taby_hardware_target(),
             taby_display_shape(),
             taby_display_width(),
             taby_display_height(),
             identity ? identity->device_id : "",
             (identity && identity->claimed) ? "true" : "false",
             (identity && identity->claimed_by[0]) ? identity->claimed_by : "",
             taby_wifi_mode_name(),
             taby_wifi_is_connected() ? "true" : "false",
             taby_wifi_ip_address() ? taby_wifi_ip_address() : "",
             taby_wifi_mdns_hostname() ? taby_wifi_mdns_hostname() : "",
             taby_wifi_station_ssid() ? taby_wifi_station_ssid() : "",
             taby_wifi_ap_ssid() ? taby_wifi_ap_ssid() : "",
             taby_transport_state_name(taby_runtime_current_state()),
             taby_wifi_last_error() ? taby_wifi_last_error() : "",
             taby_transport_onboarding_complete() ? "true" : "false",
             taby_transport_preferred_mode_name(),
             power.valid ? power.power_voltage_mv : 0,
             power.valid ? power.battery_percent : -1,
             (power.valid && power.external_power) ? "true" : "false",
             taby_mqtt_enabled() ? "true" : "false",
             taby_mqtt_connected() ? "true" : "false",
             taby_mqtt_broker_uri(),
             orientation.mode_name,
             orientation.orientation_name,
             (unsigned int)orientation.rotation_degrees,
             orientation.auto_supported ? "true" : "false",
             taby_identity_source_name(),
             (identity && identity->has_factory_data) ? "true" : "false");
    return send_json(req, "200 OK", body);
}

static esp_err_t provisioning_info_handler(httpd_req_t *req) {
    cJSON *root = build_setup_info_json();
    char *body = cJSON_PrintUnformatted(root);
    cJSON_Delete(root);
    if (!body) {
        return send_json(req, "500 Internal Server Error", "{\"ok\":false,\"error\":\"encode failed\"}");
    }
    esp_err_t result = send_json(req, "200 OK", body);
    cJSON_free(body);
    return result;
}

static bool should_serve_setup_on_root(void) {
    return taby_wifi_mode() == TABY_WIFI_MODE_SETUP_AP;
}

static esp_err_t root_page_handler(httpd_req_t *req) {
    return send_html(req,
                     "200 OK",
                     should_serve_setup_on_root() ? k_setup_page_html : k_status_page_html);
}

static esp_err_t setup_page_handler(httpd_req_t *req) {
    return send_html(req, "200 OK", k_setup_page_html);
}

static esp_err_t setup_form_submit_handler(httpd_req_t *req) {
    char body_buffer[384] = {0};
    if (req->content_len <= 0 || (size_t)req->content_len >= sizeof(body_buffer)) {
        return send_html(req, "400 Bad Request",
                         "<html><body style='font-family:sans-serif;background:#111;color:#fff;padding:24px'>"
                         "<h1>Setup failed</h1><p>Missing Wi-Fi details.</p></body></html>");
    }

    int received = httpd_req_recv(req, body_buffer, req->content_len);
    if (received <= 0) {
        return send_html(req, "400 Bad Request",
                         "<html><body style='font-family:sans-serif;background:#111;color:#fff;padding:24px'>"
                         "<h1>Setup failed</h1><p>Could not read the form.</p></body></html>");
    }
    body_buffer[received] = '\0';

    char ssid[65] = {0};
    char password[65] = {0};
    if (!read_form_field(body_buffer, "ssid", ssid, sizeof(ssid))) {
        return send_html(req, "400 Bad Request",
                         "<html><body style='font-family:sans-serif;background:#111;color:#fff;padding:24px'>"
                         "<h1>Setup failed</h1><p>Wi-Fi name is required.</p></body></html>");
    }
    read_form_field(body_buffer, "password", password, sizeof(password));

    esp_err_t err = taby_wifi_store_credentials(ssid, password);
    if (err != ESP_OK) {
        return send_html(req, "500 Internal Server Error",
                         "<html><body style='font-family:sans-serif;background:#111;color:#fff;padding:24px'>"
                         "<h1>Setup failed</h1><p>Taby could not save that Wi-Fi yet. Try again.</p></body></html>");
    }

    send_html(req, "200 OK",
              "<!doctype html><html><head><meta charset='utf-8'>"
              "<meta name='viewport' content='width=device-width,initial-scale=1'>"
              "<title>Taby connecting</title></head>"
              "<body style='margin:0;font-family:-apple-system,BlinkMacSystemFont,Segoe UI,sans-serif;"
              "background:#0b0d11;color:#f7f7f5;display:grid;place-items:center;min-height:100vh;padding:24px;box-sizing:border-box'>"
              "<main style='width:min(100%,420px);background:#141820;border:1px solid #2f3845;border-radius:24px;padding:24px;box-sizing:border-box;text-align:center'>"
              "<h1 style='margin:0 0 10px;font-size:28px'>Connecting Taby…</h1>"
              "<p style='margin:0;color:#b7bec8;font-size:15px;line-height:1.4'>Taby saved your Wi-Fi and will try connecting now. If it comes back to setup, open 192.168.4.1 in Safari or Chrome and try again.</p>"
              "</main></body></html>");
    xTaskCreate(delayed_wifi_connect_task, "taby_wifi_connect", 3072, NULL, 4, NULL);
    return ESP_OK;
}

static esp_err_t provision_handler(httpd_req_t *req) {
    char body_buffer[384];
    cJSON *root = parse_json_body(req, body_buffer, sizeof(body_buffer));
    if (!root) {
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"invalid json\"}");
    }

    const cJSON *ssid = cJSON_GetObjectItemCaseSensitive(root, "ssid");
    const cJSON *password = cJSON_GetObjectItemCaseSensitive(root, "password");
    if (!cJSON_IsString(ssid) || !ssid->valuestring || !cJSON_IsString(password) || !password->valuestring) {
        cJSON_Delete(root);
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"ssid and password required\"}");
    }

    esp_err_t err = taby_wifi_store_credentials(ssid->valuestring, password->valuestring);
    cJSON_Delete(root);
    if (err != ESP_OK) {
        return send_json(req, "500 Internal Server Error", "{\"ok\":false,\"error\":\"store failed\"}");
    }

    send_json(req, "200 OK", "{\"ok\":true,\"connecting\":true}");
    xTaskCreate(delayed_wifi_connect_task, "taby_wifi_connect", 3072, NULL, 4, NULL);
    return ESP_OK;
}

static esp_err_t transport_mode_handler(httpd_req_t *req) {
    char body_buffer[256];
    cJSON *root = parse_json_body(req, body_buffer, sizeof(body_buffer));
    if (!root) {
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"invalid json\"}");
    }

    const cJSON *mode = cJSON_GetObjectItemCaseSensitive(root, "mode");
    if (!cJSON_IsString(mode) || !mode->valuestring) {
        cJSON_Delete(root);
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"mode required\"}");
    }

    taby_transport_pref_t preferred_mode = TABY_TRANSPORT_PREF_UNKNOWN;
    if (!taby_transport_pref_from_name(mode->valuestring, &preferred_mode)) {
        cJSON_Delete(root);
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"invalid mode\"}");
    }
    cJSON_Delete(root);

    if (taby_onboarding_activate_transport_mode(preferred_mode) != ESP_OK) {
        return send_json(req, "500 Internal Server Error", "{\"ok\":false,\"error\":\"transport mode failed\"}");
    }

    return send_json(req, "200 OK", "{\"ok\":true}");
}

static esp_err_t transport_default_handler(httpd_req_t *req) {
    char body_buffer[256];
    cJSON *root = parse_json_body(req, body_buffer, sizeof(body_buffer));
    if (!root) {
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"invalid json\"}");
    }

    const cJSON *mode = cJSON_GetObjectItemCaseSensitive(root, "mode");
    if (!cJSON_IsString(mode) || !mode->valuestring) {
        cJSON_Delete(root);
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"mode required\"}");
    }

    taby_transport_pref_t preferred_mode = TABY_TRANSPORT_PREF_UNKNOWN;
    if (!taby_transport_pref_from_name(mode->valuestring, &preferred_mode)) {
        cJSON_Delete(root);
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"invalid mode\"}");
    }
    cJSON_Delete(root);

    if (taby_onboarding_set_transport_default(preferred_mode) != ESP_OK) {
        return send_json(req, "500 Internal Server Error", "{\"ok\":false,\"error\":\"transport default failed\"}");
    }

    return send_json(req, "200 OK", "{\"ok\":true}");
}

static esp_err_t setup_start_handler(httpd_req_t *req) {
    esp_err_t err = taby_wifi_start_setup_mode(taby_identity_get());
    if (err != ESP_OK) {
        return send_json(req, "500 Internal Server Error", "{\"ok\":false,\"error\":\"setup start failed\"}");
    }
    taby_onboarding_show_wifi_setup();

    cJSON *root = build_setup_info_json();
    char *body = cJSON_PrintUnformatted(root);
    cJSON_Delete(root);
    if (!body) {
        return send_json(req, "500 Internal Server Error", "{\"ok\":false,\"error\":\"encode failed\"}");
    }
    esp_err_t result = send_json(req, "200 OK", body);
    cJSON_free(body);
    return result;
}

static esp_err_t setup_status_handler(httpd_req_t *req) {
    cJSON *root = build_setup_info_json();
    char *body = cJSON_PrintUnformatted(root);
    cJSON_Delete(root);
    if (!body) {
        return send_json(req, "500 Internal Server Error", "{\"ok\":false,\"error\":\"encode failed\"}");
    }
    esp_err_t result = send_json(req, "200 OK", body);
    cJSON_free(body);
    return result;
}

static esp_err_t wifi_networks_handler(httpd_req_t *req) {
    cJSON *root = cJSON_CreateObject();
    cJSON_AddItemToObject(root, "networks", build_wifi_networks_array());
    char *body = cJSON_PrintUnformatted(root);
    cJSON_Delete(root);
    if (!body) {
        return send_json(req, "500 Internal Server Error", "{\"ok\":false,\"error\":\"encode failed\"}");
    }
    esp_err_t result = send_json(req, "200 OK", body);
    cJSON_free(body);
    return result;
}

static esp_err_t wifi_nearby_handler(httpd_req_t *req) {
    cJSON *root = cJSON_CreateObject();
    cJSON_AddItemToObject(root, "networks", build_nearby_networks_array());
    char *body = cJSON_PrintUnformatted(root);
    cJSON_Delete(root);
    if (!body) {
        return send_json(req, "500 Internal Server Error", "{\"ok\":false,\"error\":\"encode failed\"}");
    }
    esp_err_t result = send_json(req, "200 OK", body);
    cJSON_free(body);
    return result;
}

static esp_err_t wifi_forget_handler(httpd_req_t *req) {
    char body_buffer[256];
    cJSON *root = parse_json_body(req, body_buffer, sizeof(body_buffer));
    if (!root) {
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"invalid json\"}");
    }

    const cJSON *ssid = cJSON_GetObjectItemCaseSensitive(root, "ssid");
    if (!cJSON_IsString(ssid) || !ssid->valuestring) {
        cJSON_Delete(root);
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"ssid required\"}");
    }

    esp_err_t err = taby_wifi_forget_network(ssid->valuestring);
    cJSON_Delete(root);
    if (err != ESP_OK) {
        return send_json(req, "500 Internal Server Error", "{\"ok\":false,\"error\":\"forget failed\"}");
    }

    return send_json(req, "200 OK", "{\"ok\":true}");
}

static esp_err_t wifi_prefer_handler(httpd_req_t *req) {
    char body_buffer[256];
    cJSON *root = parse_json_body(req, body_buffer, sizeof(body_buffer));
    if (!root) {
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"invalid json\"}");
    }

    const cJSON *ssid = cJSON_GetObjectItemCaseSensitive(root, "ssid");
    if (!cJSON_IsString(ssid) || !ssid->valuestring) {
        cJSON_Delete(root);
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"ssid required\"}");
    }

    esp_err_t err = taby_wifi_set_preferred_network(ssid->valuestring);
    cJSON_Delete(root);
    if (err != ESP_OK) {
        return send_json(req, "500 Internal Server Error", "{\"ok\":false,\"error\":\"prefer failed\"}");
    }

    return send_json(req, "200 OK", "{\"ok\":true}");
}

static esp_err_t claim_handler(httpd_req_t *req) {
    char body_buffer[384];
    cJSON *root = parse_json_body(req, body_buffer, sizeof(body_buffer));
    if (!root) {
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"invalid json\"}");
    }

    const cJSON *claimed_by = cJSON_GetObjectItemCaseSensitive(root, "claimed_by");
    const char *value = (cJSON_IsString(claimed_by) && claimed_by->valuestring) ? claimed_by->valuestring : "claimed";
    esp_err_t err = taby_identity_set_claim(value);
    cJSON_Delete(root);
    if (err != ESP_OK) {
        return send_json(req, "500 Internal Server Error", "{\"ok\":false,\"error\":\"claim failed\"}");
    }

    return send_json(req, "200 OK", "{\"ok\":true}");
}

static esp_err_t display_orientation_get_handler(httpd_req_t *req) {
    return send_display_orientation_json(req, true);
}

static esp_err_t display_orientation_post_handler(httpd_req_t *req) {
    char body_buffer[128];
    cJSON *root = parse_json_body(req, body_buffer, sizeof(body_buffer));
    if (!root) {
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"invalid json\"}");
    }

    const cJSON *mode_json = cJSON_GetObjectItemCaseSensitive(root, "mode");
    taby_display_orientation_mode_t mode = TABY_DISPLAY_ORIENTATION_MODE_LEFT;
    bool valid = cJSON_IsString(mode_json) && mode_json->valuestring &&
        board_amoled_1_64_parse_display_orientation_mode(mode_json->valuestring, &mode);
    cJSON_Delete(root);
    if (!valid) {
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"invalid mode\"}");
    }

    return apply_display_orientation_http_command(req, false, mode);
}

static esp_err_t factory_reset_handler(httpd_req_t *req) {
    esp_err_t wifi_err = taby_wifi_clear_credentials();
    esp_err_t claim_err = taby_identity_clear_claim();
    esp_err_t transport_err = taby_transport_clear_onboarding();
    bool display_orientation_ok = taby_runtime_reset_display_orientation();
    if (wifi_err != ESP_OK ||
        claim_err != ESP_OK ||
        transport_err != ESP_OK ||
        !display_orientation_ok) {
        return send_json(req, "500 Internal Server Error", "{\"ok\":false,\"error\":\"factory reset failed\"}");
    }

    send_json(req, "200 OK", "{\"ok\":true,\"restart\":true}");
    xTaskCreate(delayed_restart_task, "taby_restart", 2048, NULL, 4, NULL);
    return ESP_OK;
}

static esp_err_t onboarding_reset_handler(httpd_req_t *req) {
    esp_err_t transport_err = taby_transport_clear_onboarding();
    if (transport_err != ESP_OK) {
        return send_json(req, "500 Internal Server Error", "{\"ok\":false,\"error\":\"onboarding reset failed\"}");
    }

    taby_onboarding_start();
    return send_json(req, "200 OK", "{\"ok\":true}");
}

static esp_err_t command_v1_handler(httpd_req_t *req) {
    char body_buffer[2048];
    cJSON *root = parse_json_body(req, body_buffer, sizeof(body_buffer));
    if (!root) {
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"invalid json\"}");
    }

    const cJSON *command_json = cJSON_GetObjectItemCaseSensitive(root, "command");
    if (!cJSON_IsString(command_json) || !command_json->valuestring) {
        cJSON_Delete(root);
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"command required\"}");
    }

    bool orientation_query = false;
    taby_display_orientation_mode_t orientation_mode = TABY_DISPLAY_ORIENTATION_MODE_LEFT;
    if (parse_display_orientation_command(
            command_json->valuestring,
            &orientation_query,
            &orientation_mode)) {
        cJSON_Delete(root);
        return apply_display_orientation_http_command(
            req,
            orientation_query,
            orientation_mode);
    }

    const char *reusable_ui_command = reusable_ui_command_from_command(command_json->valuestring);
    if (reusable_ui_command) {
        char ui_error[96] = {0};
        cJSON_Delete(root);

        if (!taby_reusable_preview_render_ui_command(reusable_ui_command, ui_error, sizeof(ui_error))) {
            char body[160];
            snprintf(
                body,
                sizeof(body),
                "{\"ok\":false,\"error\":\"%s\"}",
                ui_error[0] ? ui_error : "ui render failed");
            return send_json(req, "400 Bad Request", body);
        }

        taby_mqtt_notify_state_changed("http_ui_command");
        return send_json(req, "200 OK", "{\"ok\":true}");
    }

    taby_transport_resolution_t resolution = {0};
    bool parsed = taby_transport_resolve_text(command_json->valuestring, &resolution);
    cJSON_Delete(root);

    if (!parsed) {
        return send_json(req, "400 Bad Request", "{\"ok\":false,\"error\":\"unknown command\"}");
    }

    taby_runtime_apply_transport_resolution(&resolution);
    taby_mqtt_notify_state_changed("http_command");
    return send_json(req, "200 OK", "{\"ok\":true}");
}

esp_err_t taby_http_server_start(void) {
    if (s_server) {
        return ESP_OK;
    }

    httpd_config_t config = HTTPD_DEFAULT_CONFIG();
    config.max_uri_handlers = 30;

    ESP_RETURN_ON_ERROR(httpd_start(&s_server, &config), TAG, "http start failed");

    const httpd_uri_t ping_uri = {
        .uri = "/ping", .method = HTTP_GET, .handler = ping_handler, .user_ctx = NULL,
    };
    const httpd_uri_t setup_page_uri = {
        .uri = "/", .method = HTTP_GET, .handler = root_page_handler, .user_ctx = NULL,
    };
    const httpd_uri_t setup_page_alt_uri = {
        .uri = "/setup", .method = HTTP_GET, .handler = setup_page_handler, .user_ctx = NULL,
    };
    const httpd_uri_t setup_submit_uri = {
        .uri = "/setup", .method = HTTP_POST, .handler = setup_form_submit_handler, .user_ctx = NULL,
    };
    const httpd_uri_t state_uri = {
        .uri = "/state", .method = HTTP_GET, .handler = state_handler, .user_ctx = NULL,
    };
    const httpd_uri_t touch_uri = {
        .uri = "/touch", .method = HTTP_GET, .handler = touch_handler, .user_ctx = NULL,
    };
    const httpd_uri_t reusable_choice_signal_uri = {
        .uri = "/v1/reusable/choice-signal", .method = HTTP_GET, .handler = reusable_choice_signal_handler, .user_ctx = NULL,
    };
    const httpd_uri_t compat_cmd_uri = {
        .uri = "/cmd", .method = HTTP_GET, .handler = compat_command_handler, .user_ctx = NULL,
    };
    const httpd_uri_t health_uri = {
        .uri = "/v1/health", .method = HTTP_GET, .handler = health_handler, .user_ctx = NULL,
    };
    const httpd_uri_t provisioning_info_uri = {
        .uri = "/v1/provisioning/info", .method = HTTP_GET, .handler = provisioning_info_handler, .user_ctx = NULL,
    };
    const httpd_uri_t provision_uri = {
        .uri = "/v1/provision", .method = HTTP_POST, .handler = provision_handler, .user_ctx = NULL,
    };
    const httpd_uri_t setup_start_uri = {
        .uri = "/v1/setup/start", .method = HTTP_POST, .handler = setup_start_handler, .user_ctx = NULL,
    };
    const httpd_uri_t setup_status_uri = {
        .uri = "/v1/setup/status", .method = HTTP_GET, .handler = setup_status_handler, .user_ctx = NULL,
    };
    const httpd_uri_t wifi_networks_uri = {
        .uri = "/v1/wifi/networks", .method = HTTP_GET, .handler = wifi_networks_handler, .user_ctx = NULL,
    };
    const httpd_uri_t wifi_nearby_uri = {
        .uri = "/v1/wifi/nearby", .method = HTTP_GET, .handler = wifi_nearby_handler, .user_ctx = NULL,
    };
    const httpd_uri_t wifi_forget_uri = {
        .uri = "/v1/wifi/forget", .method = HTTP_POST, .handler = wifi_forget_handler, .user_ctx = NULL,
    };
    const httpd_uri_t wifi_prefer_uri = {
        .uri = "/v1/wifi/prefer", .method = HTTP_POST, .handler = wifi_prefer_handler, .user_ctx = NULL,
    };
    const httpd_uri_t claim_uri = {
        .uri = "/v1/claim", .method = HTTP_POST, .handler = claim_handler, .user_ctx = NULL,
    };
    const httpd_uri_t display_orientation_get_uri = {
        .uri = "/v1/display-orientation", .method = HTTP_GET, .handler = display_orientation_get_handler, .user_ctx = NULL,
    };
    const httpd_uri_t display_orientation_post_uri = {
        .uri = "/v1/display-orientation", .method = HTTP_POST, .handler = display_orientation_post_handler, .user_ctx = NULL,
    };
    const httpd_uri_t transport_mode_uri = {
        .uri = "/v1/transport-mode", .method = HTTP_POST, .handler = transport_mode_handler, .user_ctx = NULL,
    };
    const httpd_uri_t transport_default_uri = {
        .uri = "/v1/transport-default", .method = HTTP_POST, .handler = transport_default_handler, .user_ctx = NULL,
    };
    const httpd_uri_t factory_reset_uri = {
        .uri = "/v1/factory-reset", .method = HTTP_POST, .handler = factory_reset_handler, .user_ctx = NULL,
    };
    const httpd_uri_t onboarding_reset_uri = {
        .uri = "/v1/onboarding/reset", .method = HTTP_POST, .handler = onboarding_reset_handler, .user_ctx = NULL,
    };
    const httpd_uri_t command_v1_uri = {
        .uri = "/v1/command", .method = HTTP_POST, .handler = command_v1_handler, .user_ctx = NULL,
    };

    httpd_register_uri_handler(s_server, &setup_page_uri);
    httpd_register_uri_handler(s_server, &setup_page_alt_uri);
    httpd_register_uri_handler(s_server, &setup_submit_uri);
    httpd_register_uri_handler(s_server, &ping_uri);
    httpd_register_uri_handler(s_server, &state_uri);
    httpd_register_uri_handler(s_server, &touch_uri);
    httpd_register_uri_handler(s_server, &reusable_choice_signal_uri);
    httpd_register_uri_handler(s_server, &compat_cmd_uri);
    httpd_register_uri_handler(s_server, &health_uri);
    httpd_register_uri_handler(s_server, &provisioning_info_uri);
    httpd_register_uri_handler(s_server, &provision_uri);
    httpd_register_uri_handler(s_server, &setup_start_uri);
    httpd_register_uri_handler(s_server, &setup_status_uri);
    httpd_register_uri_handler(s_server, &wifi_networks_uri);
    httpd_register_uri_handler(s_server, &wifi_nearby_uri);
    httpd_register_uri_handler(s_server, &wifi_forget_uri);
    httpd_register_uri_handler(s_server, &wifi_prefer_uri);
    httpd_register_uri_handler(s_server, &claim_uri);
    httpd_register_uri_handler(s_server, &display_orientation_get_uri);
    httpd_register_uri_handler(s_server, &display_orientation_post_uri);
    httpd_register_uri_handler(s_server, &transport_mode_uri);
    httpd_register_uri_handler(s_server, &transport_default_uri);
    httpd_register_uri_handler(s_server, &factory_reset_uri);
    httpd_register_uri_handler(s_server, &onboarding_reset_uri);
    httpd_register_uri_handler(s_server, &command_v1_uri);
    ESP_LOGI(TAG, "http server started port=80 endpoints=/setup /v1/health /v1/provisioning/info /v1/wifi/nearby");
    return ESP_OK;
}

void taby_http_server_stop(void) {
    if (!s_server) {
        return;
    }

    httpd_stop(s_server);
    s_server = NULL;
    ESP_LOGI(TAG, "http server stopped");
}
