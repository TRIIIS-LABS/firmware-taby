// Taby talking live: the app's VOICE_MOTION lines, played on the device's own
// clock (app-taby physical/contracts/src/voice-motion.ts, draft ADR
// device-live-talk).
//
//   VOICE_MOTION <talk> <clockMs> <atMs> <frames>
//   VOICE_MOTION <talk> stop
//
// A run is up to 60 frames at 30 a second, three letters a frame: the mouth
// shape, the jaw in 64 steps, and gesture * 4 + expression. `clockMs` is where
// the app's voice is as the line is sent; the device keeps its own clock from
// the first run of a piece and moves it only when a later run says it is
// clearly off, so a line that arrives a little late moves nothing.
#pragma once

#include "taby_character.hpp"

#include <cstdint>
#include <vector>

namespace taby
{

class VoiceMotion
{
public:
  /** Takes what follows "VOICE_MOTION "; false if it is not a valid line. */
  bool take(const char* args, double nowMs);
  /** The frame for now: the mouth shut outside the frames or once stopped. */
  SpeechFrame at(double nowMs) const;
  /** A piece is playing, or has frames still ahead. */
  bool active(double nowMs) const;
  /** Forget everything (the face left talking). */
  void reset();

private:
  struct Frame
  {
    uint8_t viseme;
    uint8_t jaw;
    uint8_t pose;
  };
  int m_talk = -1;
  bool m_stopped = true;
  /** Device time at which the voice was at zero. */
  double m_zeroAt = 0;
  std::vector<Frame> m_frames;
  /** Which frames have arrived; a gap is a shut mouth, not a stale one. */
  std::vector<bool> m_have;
};

} // namespace taby
