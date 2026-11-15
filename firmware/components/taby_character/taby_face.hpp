// The board's live face: Taby resting, listening and talking as the desktop
// notch's character, moving between them by the character's own transitions
// (Peter, 2026-11-15: "the listening now instantly goes from idle, no cool
// smooth rive transition?"). The clips the face also plays (the wizard, the
// bricks, the magnifier, the waiting answer, success clips) stay GIFs; the
// face hands over to one from its neutral resting face and comes back to it,
// which is where those clips start and end.
//
// Nothing here touches the board: the firmware draws what this decides, and
// a host program plays it the same way.
#pragma once

#include "taby_character.hpp"

#include <cstdint>

namespace taby
{

/**
 * Where the character goes on the 1.64 panel (280 x 456, portrait), from
 * its landscape frame (the artboard fitted into 456 x 280), as a matrix
 * x' = a*u + c*v + e, y' = b*u + d*v + f. The GIF pack draws Taby's resting
 * face at 0.868 of the character's own size, its eyes centred at (136.5,
 * 233.5) (working_in's first frame, the waiting answer's way in, thumbs_up's
 * last), so the character rests in the same place and a clip cuts in on
 * the same face. Up is the panel's +x, as in the pack.
 */
struct Placement
{
  float a, b, c, d, e, f;
};
constexpr float kPanelScale = 0.868f;
constexpr Placement kPanelPlacement = {0,
                                       kPanelScale,
                                       -kPanelScale,
                                       0,
                                       kPanelScale * (280 - 144.0f) + 136.5f,
                                       233.5f - kPanelScale * 229.5f};

/** What the face shows live, as the app names its clips. */
enum class Face
{
  idle,      // idle_01_loop
  listening, // listening_loop
  talking,   // talking_default_loop
};

/** The Eyes setting (ADR 0496 in app-taby): how much the resting face moves. */
enum class Eyes
{
  normal, // the character's own idle loop: blinks, tilts, looks to each side
  calm,   // the neutral face, a blink every few seconds, a small tilt now and then
  still,  // the neutral face, eyes centred, gentle blinks only
};

class LiveFace
{
public:
  /** Any 32-bit random value. */
  using Random = uint32_t (*)();

  LiveFace(Character& character, Random random);

  /** Where the face should be. Taken on the next advance. */
  void show(Face face);
  Face face() const { return m_face; }
  void setEyes(Eyes eyes);

  /** A clip is about to take over: the face goes to its neutral rest. */
  void handOver();
  /** The face is back: it goes where show() says from where it is. */
  void takeBack();
  bool handingOver() const { return m_handOver; }

  /** Back from a clip with the character elsewhere: it is settled on the
   *  neutral face at once, nothing drawn, so its first frame meets the
   *  clip's last. Its clock runs ahead by what that took. */
  void startFromRest(double nowMs);

  /** One frame at `nowMs`. `speech` is the app's mouth motion now, used
   *  while talking. Returns whether the picture may have changed. */
  bool advance(float seconds, double nowMs, const SpeechFrame* speech);

  /** Resting on the neutral face long enough for a clip to cut in. */
  bool atRest(double nowMs) const;

  /** How long to wait before the next frame: listening and talking at
   *  30 fps, the idle loop at 20 fps (the idle GIF's own pace), and a still
   *  face only checks back for its next blink. */
  double frameMs() const;

private:
  double clock(double nowMs) const { return nowMs + m_aheadMs; }
  Mode wanted() const;
  /** Calm or still, resting between blinks: nothing to advance or draw. */
  bool quiet(double now) const;
  void restPlan(double nowMs);
  void scheduleBlink(double nowMs);

  Character& m_character;
  Random m_random;
  Face m_face = Face::idle;
  Eyes m_eyes = Eyes::normal;
  bool m_handOver = false;
  double m_aheadMs = 0;
  double m_restSince = -1e12;
  bool m_moved = true;
  // Something the character does not report moved it: a blink fired, or
  // the face came back from a clip.
  bool m_kick = true;
  // Calm and still: the neutral face, with blinks and (calm) a tilt.
  double m_nextBlinkAt = -1;
  double m_blinkAt = -1e12;
  int m_blinksBeforeTilt = 0;
  double m_tiltUntil = -1;
};

} // namespace taby
