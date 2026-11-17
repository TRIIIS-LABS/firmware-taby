// A stand-in for firmware/components/taby_character/taby_character.hpp, for
// tests/test_live_face.py: what LiveFace asks of the character, without
// Rive. Every call it makes is printed as a JSON line.
//
// It settles as the real one does, roughly: a rest is reached 200 ms after
// it is asked for, an authored action (idle loop, listening) holds the body
// for 300 ms after it starts, and the state machine always reports that it
// is still going (the real file's loops never settle).
#pragma once

#include <cstdio>
#include <string>
#include <vector>

namespace taby
{

struct SpeechFrame
{
  std::string viseme = "sil";
  float jawOpen = 0;
  std::string gesture = "idle";
  std::string expression = "idle";
};

enum class Mode
{
  idle,
  working,
  listening,
  ready,
  speaking,
  rest,
};

inline const char* modeName(Mode mode)
{
  switch (mode)
  {
    case Mode::idle: return "idle";
    case Mode::working: return "working";
    case Mode::listening: return "listening";
    case Mode::ready: return "ready";
    case Mode::speaking: return "speaking";
    case Mode::rest: return "rest";
  }
  return "idle";
}

class Character
{
public:
  void setMode(Mode mode, double nowMs)
  {
    if (mode == m_mode) return;
    m_mode = mode;
    m_since = nowMs;
    std::printf("{\"event\":\"mode\",\"mode\":\"%s\",\"t\":%.1f}\n", modeName(mode), nowMs);
  }
  Mode mode() const { return m_mode; }
  double restingMs(double nowMs) const
  {
    return m_mode == Mode::rest && nowMs - m_since >= 200 ? nowMs - m_since - 200 : 0;
  }
  bool layersFree() const { return m_last - m_since >= 300 || (m_mode != Mode::idle && m_mode != Mode::listening && m_mode != Mode::speaking); }
  void blink() { ++m_blinks; }
  /** How many blinks were fired; the driver prints them at their frame. */
  int blinks() const { return m_blinks; }
  void applySpeech(const SpeechFrame& frame, double nowMs)
  {
    std::printf("{\"event\":\"speech\",\"gesture\":\"%s\",\"t\":%.1f}\n", frame.gesture.c_str(), nowMs);
  }
  std::vector<std::string> advance(float, double nowMs)
  {
    m_last = nowMs;
    return {};
  }
  bool moving() const { return true; }

private:
  Mode m_mode = Mode::idle;
  double m_since = 0;
  double m_last = 0;
  int m_blinks = 0;
};

} // namespace taby
