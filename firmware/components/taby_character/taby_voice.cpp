#include "taby_voice.hpp"

#include <cmath>
#include <cstdlib>
#include <cstring>

namespace taby
{
namespace
{

constexpr double kFps = 30.0;
constexpr size_t kMostFrames = 3600; // two minutes, as the app sends at most
constexpr size_t kRunFrames = 60;
/** A later run moves the clock only when it says it is this far off. */
constexpr double kClockSlackMs = 80.0;

const char* const kVisemes[] = {"sil", "PP", "FF", "TH", "DD", "kk", "CH", "SS",
                                "nn",  "RR", "aa", "E",  "I",  "O",  "U"};
const char* const kGestures[] = {"idle", "ask", "oneHand", "nod", "shrug", "hi", "hello"};
const char* const kExpressions[] = {"idle", "happy", "serious", "closeEye"};
constexpr int kVisemeCount = sizeof(kVisemes) / sizeof(kVisemes[0]);
constexpr int kPoseCount = 7 * 4;

int letter(char c)
{
  if (c >= 'A' && c <= 'Z') return c - 'A';
  if (c >= 'a' && c <= 'z') return 26 + c - 'a';
  if (c >= '0' && c <= '9') return 52 + c - '0';
  if (c == '-') return 62;
  if (c == '_') return 63;
  return -1;
}

/** Reads a non-negative whole number and the one space after it. */
bool number(const char** at, long* value)
{
  char* end = nullptr;
  const long read = std::strtol(*at, &end, 10);
  if (end == *at || read < 0) return false;
  *value = read;
  *at = end;
  if (**at == ' ') ++*at;
  return true;
}

} // namespace

bool VoiceMotion::take(const char* args, double nowMs)
{
  const char* at = args;
  long talk = 0;
  if (!number(&at, &talk) || talk > 65535) return false;
  if (std::strcmp(at, "stop") == 0)
  {
    if (talk == m_talk) m_stopped = true;
    return true;
  }
  long clockMs = 0, atMs = 0;
  if (!number(&at, &clockMs) || !number(&at, &atMs)) return false;
  const size_t letters = std::strlen(at);
  if (letters == 0 || letters % 3 != 0 || letters / 3 > kRunFrames) return false;
  std::vector<Frame> run;
  run.reserve(letters / 3);
  for (size_t i = 0; i < letters; i += 3)
  {
    const int v = letter(at[i]), j = letter(at[i + 1]), p = letter(at[i + 2]);
    if (v < 0 || v >= kVisemeCount || j < 0 || p < 0 || p >= kPoseCount) return false;
    run.push_back({static_cast<uint8_t>(v), static_cast<uint8_t>(j), static_cast<uint8_t>(p)});
  }

  const double zeroAt = nowMs - static_cast<double>(clockMs);
  if (talk != m_talk || m_stopped)
  {
    // A new piece of voice: it replaces whatever came before.
    m_talk = static_cast<int>(talk);
    m_stopped = false;
    m_frames.clear();
    m_have.clear();
    m_zeroAt = zeroAt;
  }
  else if (std::fabs(zeroAt - m_zeroAt) > kClockSlackMs)
  {
    m_zeroAt = zeroAt;
  }
  const size_t first = static_cast<size_t>(std::lround(atMs * kFps / 1000.0));
  if (first + run.size() > kMostFrames) return false;
  if (m_frames.size() < first + run.size())
  {
    m_frames.resize(first + run.size());
    m_have.resize(first + run.size(), false);
  }
  for (size_t i = 0; i < run.size(); ++i)
  {
    m_frames[first + i] = run[i];
    m_have[first + i] = true;
  }
  return true;
}

SpeechFrame VoiceMotion::at(double nowMs) const
{
  SpeechFrame frame;
  if (m_stopped || m_talk < 0) return frame;
  const double ms = nowMs - m_zeroAt;
  if (ms < 0) return frame;
  const size_t index = static_cast<size_t>(ms * kFps / 1000.0);
  if (index >= m_frames.size() || !m_have[index]) return frame;
  const Frame& f = m_frames[index];
  frame.viseme = kVisemes[f.viseme];
  frame.jawOpen = f.jaw * 100.0f / 63.0f;
  frame.gesture = kGestures[f.pose / 4];
  frame.expression = kExpressions[f.pose % 4];
  return frame;
}

bool VoiceMotion::active(double nowMs) const
{
  return !m_stopped && m_talk >= 0 &&
         nowMs - m_zeroAt < m_frames.size() * 1000.0 / kFps;
}

void VoiceMotion::reset()
{
  m_talk = -1;
  m_stopped = true;
  m_frames.clear();
  m_have.clear();
}

} // namespace taby
