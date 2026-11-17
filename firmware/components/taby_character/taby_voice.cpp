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
/** The app sends a piece's first run as its voice starts, about when the face
 *  turns to talking; one this much earlier still belongs to the talk. */
constexpr double kRunBeforeTalkMs = 3000.0;
/** How long talking waits for the app's first run before Taby talks alone. */
constexpr double kOwnTalkWaitMs = 500.0;
/** Taby's own talk loops after about this many frames. */
constexpr size_t kOwnTalkFrames = 300;
constexpr double kPi = 3.14159265358979323846;

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

struct OwnFrame
{
  uint8_t viseme;
  uint8_t jaw; // 0 to 100
};

/** Phrases of words of syllables, each an optional consonant and a vowel whose
 *  jaw opens and closes, with pauses between: the same talk every time. */
const std::vector<OwnFrame>& ownFrames()
{
  static const std::vector<OwnFrame> frames = [] {
    std::vector<OwnFrame> out;
    uint32_t seed = 0x7461u;
    auto next = [&seed](int lo, int hi) {
      seed = seed * 1664525u + 1013904223u;
      return lo + static_cast<int>((seed >> 16) % static_cast<uint32_t>(hi - lo + 1));
    };
    auto hold = [&out](uint8_t viseme, int jaw, int count) {
      for (int i = 0; i < count; ++i) out.push_back({viseme, static_cast<uint8_t>(jaw)});
    };
    // PP to RR, and the vowels with "aa" twice, as often as speech has it.
    const uint8_t consonants[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    const uint8_t vowels[] = {10, 10, 11, 12, 13, 14};
    while (out.size() < kOwnTalkFrames)
    {
      for (int words = next(3, 7); words > 0; --words)
      {
        for (int syllables = next(1, 3); syllables > 0; --syllables)
        {
          if (next(0, 9) < 8) hold(consonants[next(0, 8)], next(8, 20), next(2, 3));
          const uint8_t vowel = vowels[next(0, 5)];
          const int peak = next(40, 85), length = next(3, 6);
          for (int i = 0; i < length; ++i)
            hold(vowel, static_cast<int>(std::lround(peak * std::sin(kPi * (i + 1) / (length + 1)))), 1);
        }
        if (next(0, 1) == 0) hold(0, 0, next(1, 3));
      }
      hold(0, 0, next(8, 16));
    }
    return out;
  }();
  return frames;
}

} // namespace

SpeechFrame ownTalk(double ms)
{
  SpeechFrame frame;
  frame.expression = "happy";
  if (ms < 0) return frame;
  const std::vector<OwnFrame>& frames = ownFrames();
  const OwnFrame& f = frames[static_cast<size_t>(ms * kFps / 1000.0) % frames.size()];
  frame.viseme = kVisemes[f.viseme];
  frame.jawOpen = f.jaw;
  return frame;
}

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

  m_lastRunAt = nowMs;
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

SpeechFrame VoiceMotion::mouth(double nowMs, double talkingSinceMs) const
{
  if (m_lastRunAt >= talkingSinceMs - kRunBeforeTalkMs) return at(nowMs);
  const double own = nowMs - talkingSinceMs - kOwnTalkWaitMs;
  return own < 0 ? SpeechFrame() : ownTalk(own);
}

void VoiceMotion::reset()
{
  m_talk = -1;
  m_stopped = true;
  m_frames.clear();
  m_have.clear();
}

} // namespace taby
