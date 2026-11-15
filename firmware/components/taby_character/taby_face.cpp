#include "taby_face.hpp"

namespace taby
{
namespace
{

// As taby_eye_motion.h holds the idle GIF's resting face between passes.
constexpr uint32_t kStillBlinkMinMs = 4000;
constexpr uint32_t kStillBlinkMaxMs = 9000;
constexpr uint32_t kCalmBlinkMinMs = 3000;
constexpr uint32_t kCalmBlinkMaxMs = 7000;
constexpr uint32_t kCalmBlinksMin = 5;
constexpr uint32_t kCalmBlinksMax = 8;
// Calm's small tilt: the idle loop opens with one, and is let go after it.
constexpr double kTiltMs = 1300;
// A clip cuts in once the face has rested this long on the neutral face,
// past its blend there (the mouth closing, an action's exit).
constexpr double kRestedMs = 150;
constexpr double kRestBlendMs = 400;
// How far a face back from a clip is run ahead to reach the neutral face.
constexpr double kStepMs = 50;
constexpr int kMaxSteps = 30;

// Calm and still hold the neutral face between blinks: nothing moves, so
// nothing is advanced or drawn until the next blink (the state machine's own
// loops never report settling).
constexpr double kBlinkMs = 1500;
constexpr double kQuietAfterMs = 1000;

constexpr double kLiveFrameMs = 1000.0 / 30;
constexpr double kIdleFrameMs = 50;
constexpr double kStillCheckMs = 100;

uint32_t between(uint32_t low, uint32_t high, uint32_t random)
{
  return low + random % (high - low + 1U);
}

} // namespace

LiveFace::LiveFace(Character& character, Random random) :
    m_character(character), m_random(random)
{}

void LiveFace::show(Face face) { m_face = face; }

void LiveFace::setEyes(Eyes eyes) { m_eyes = eyes; }

void LiveFace::handOver() { m_handOver = true; }

void LiveFace::takeBack() { m_handOver = false; }

Mode LiveFace::wanted() const
{
  if (m_handOver)
  {
    return Mode::rest;
  }
  switch (m_face)
  {
    case Face::talking:
      return Mode::speaking;
    case Face::listening:
      return Mode::listening;
    case Face::idle:
      break;
  }
  if (m_eyes == Eyes::normal || m_tiltUntil >= 0)
  {
    return Mode::idle;
  }
  return Mode::rest;
}

void LiveFace::scheduleBlink(double now)
{
  const bool still = m_eyes == Eyes::still;
  m_nextBlinkAt = now + between(still ? kStillBlinkMinMs : kCalmBlinkMinMs,
                                still ? kStillBlinkMaxMs : kCalmBlinkMaxMs,
                                m_random());
}

void LiveFace::restPlan(double now)
{
  if (m_handOver || m_face != Face::idle || m_eyes == Eyes::normal)
  {
    m_nextBlinkAt = -1;
    m_tiltUntil = -1;
    return;
  }
  if (m_tiltUntil >= 0)
  {
    if (now >= m_tiltUntil)
    {
      m_tiltUntil = -1;
      scheduleBlink(now);
    }
    return;
  }
  if (m_nextBlinkAt < 0)
  {
    m_blinksBeforeTilt = int(between(kCalmBlinksMin, kCalmBlinksMax, m_random()));
    scheduleBlink(now);
    return;
  }
  if (now < m_nextBlinkAt)
  {
    return;
  }
  if (m_eyes == Eyes::calm && m_blinksBeforeTilt <= 0)
  {
    m_tiltUntil = now + kTiltMs;
    m_blinksBeforeTilt = int(between(kCalmBlinksMin, kCalmBlinksMax, m_random()));
    return;
  }
  m_character.blink();
  m_blinkAt = now;
  --m_blinksBeforeTilt;
  m_kick = true;
  scheduleBlink(now);
}

void LiveFace::startFromRest(double nowMs)
{
  const double now = clock(nowMs);
  if (m_character.mode() != Mode::rest)
  {
    m_character.setMode(Mode::rest, now);
    m_restSince = now;
  }
  double t = now;
  for (int step = 0; step < kMaxSteps &&
                     !(m_character.restingMs(t) >= kRestedMs && t - m_restSince >= kRestBlendMs);
       ++step)
  {
    t += kStepMs;
    m_character.advance(float(kStepMs / 1000), t);
  }
  m_aheadMs += t - now;
  m_kick = true;
}

bool LiveFace::advance(float seconds, double nowMs, const SpeechFrame* speech)
{
  const double now = clock(nowMs);
  restPlan(now);
  if (quiet(now))
  {
    m_moved = false;
    return false;
  }
  bool changed = m_kick;
  m_kick = false;
  const Mode mode = wanted();
  if (mode != m_character.mode())
  {
    m_character.setMode(mode, now);
    if (mode == Mode::rest)
    {
      m_restSince = now;
    }
    changed = true;
  }
  if (mode == Mode::speaking && speech != nullptr)
  {
    SpeechFrame frame = *speech;
    // The body takes a gesture once the action before it has let go.
    if (!m_character.layersFree())
    {
      frame.gesture = "idle";
    }
    m_character.applySpeech(frame, now);
    changed = true;
  }
  m_character.advance(seconds, now);
  m_moved = changed || m_character.moving();
  return m_moved;
}

bool LiveFace::quiet(double now) const
{
  return !m_kick && !m_handOver && m_face == Face::idle && m_eyes != Eyes::normal &&
         m_tiltUntil < 0 && m_character.mode() == Mode::rest &&
         m_character.restingMs(now) >= kRestedMs && now - m_restSince >= kQuietAfterMs &&
         now - m_blinkAt >= kBlinkMs;
}

bool LiveFace::atRest(double nowMs) const
{
  const double now = clock(nowMs);
  return m_character.mode() == Mode::rest && m_character.restingMs(now) >= kRestedMs &&
         now - m_restSince >= kRestBlendMs;
}

double LiveFace::frameMs() const
{
  if (m_handOver || m_face != Face::idle)
  {
    return kLiveFrameMs;
  }
  if (m_eyes == Eyes::normal || m_tiltUntil >= 0)
  {
    return kIdleFrameMs;
  }
  return m_moved ? kLiveFrameMs : kStillCheckMs;
}

} // namespace taby
