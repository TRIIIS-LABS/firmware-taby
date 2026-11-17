#include "taby_stars.hpp"

#include "rive/animation/linear_animation.hpp"
#include "rive/script_input_number.hpp"
#include "rive/scripted/scripted_drawable.hpp"

#include <algorithm>
#include <cmath>
#include <cstring>

namespace taby
{
namespace
{

constexpr float kPi = 3.14159265358979f;
constexpr float kTwoPi = 2 * kPi;
constexpr float kDegrees = kPi / 180;
// Past this many the oldest are let go first: a guard for the board's frame,
// above what the file's flowRate and lifespan ever keep alive.
constexpr size_t kMostStars = 160;

constexpr const char* kInputNames[] = {
    "direction",   "flowRate",      "lifespan",       "spread",
    "velocity",    "angle",         "gravity",        "speed",
    "spawnRadius", "sizeAtBirth",   "sizeAtDeath",    "rotationSpeed",
    "rotationRandom", "spreadAtDeath", "emitterX",    "emitterY",
};

} // namespace

bool Stars::bind(const rive::File& file, rive::ArtboardInstance& artboard)
{
  m_drawable = nullptr;
  for (rive::Core* object : artboard.objects())
  {
    if (object == nullptr) continue;
    if (m_drawable == nullptr && object->is<rive::ScriptedDrawable>())
    {
      m_drawable = object->as<rive::ScriptedDrawable>();
    }
    else if (object->is<rive::ScriptInputNumber>())
    {
      auto* number = object->as<rive::ScriptInputNumber>();
      for (int i = 0; i < kInputCount; ++i)
      {
        if (m_inputs[i] == nullptr && number->name() == kInputNames[i])
        {
          m_inputs[i] = number;
        }
      }
    }
  }
  // The script names its star `starComponen` (the editor's cut of
  // starComponent): an artboard with one shape whose colour its own
  // timeline animates from a star's birth.
  m_star = file.artboardNamed("starComponen");
  if (m_drawable == nullptr || m_star == nullptr || m_star->animationCount() == 0)
  {
    m_drawable = nullptr;
    m_star = nullptr;
    return false;
  }
  m_star->frameOrigin(true);
  m_starTimeline = m_star->animation(size_t(0));
  m_starTimeline->apply(m_star.get(), 0);
  m_star->advance(0);
  m_stars.reserve(kMostStars);
  return true;
}

float Stars::input(Input which) const
{
  return m_inputs[which] != nullptr ? m_inputs[which]->propertyValue() : 0.0f;
}

float Stars::random()
{
  m_seed = m_seed * 1664525u + 1013904223u;
  return float(m_seed >> 8) / float(1u << 24);
}

void Stars::clear()
{
  m_stars.clear();
  m_emitAccum = 0;
}

void Stars::spawn()
{
  if (m_stars.size() >= kMostStars)
  {
    m_stars.erase(m_stars.begin());
  }
  Star p;
  float ox = 0, oy = 0;
  const float radius = input(kSpawnRadius);
  if (radius > 0)
  {
    const float d = radius * std::sqrt(random());
    const float a = random() * kPi * 2;
    ox = std::cos(a) * d;
    oy = std::sin(a) * d;
  }
  p.x = input(kEmitterX) + ox;
  p.y = input(kEmitterY) + oy;
  p.centerAngle = (input(kDirection) + input(kAngle)) * kDegrees;
  p.spreadBirth = input(kSpread) * kDegrees;
  p.launchAngle = p.centerAngle + (random() * 2 - 1) * p.spreadBirth;
  p.baseSpeed = (input(kVelocity) * 100 + input(kSpeed)) * (0.8f + random() * 0.4f);
  p.scale = 0.7f + random() * 0.6f;
  const float turn = 0.5f < random() ? 1.0f : -1.0f;
  p.rotSpeed = (input(kRotationSpeed) + turn * random() * input(kRotationRandom)) * kDegrees;
  p.rotation = random() * kPi * 2;
  p.vx = std::cos(p.launchAngle) * p.baseSpeed;
  p.vy = std::sin(p.launchAngle) * p.baseSpeed;
  p.age = 0;
  p.lifespan = input(kLifespan);
  p.sizeAtBirth = input(kSizeAtBirth);
  p.sizeAtDeath = input(kSizeAtDeath);
  p.spreadDeath = input(kSpreadAtDeath) * kDegrees;
  m_stars.push_back(p);
}

void Stars::advance(float seconds, bool emitting)
{
  if (m_drawable == nullptr)
  {
    return;
  }
  if (emitting)
  {
    m_emitAccum += seconds * input(kFlowRate);
    while (m_emitAccum >= 1)
    {
      m_emitAccum -= 1;
      spawn();
    }
  }
  const float gravity = input(kGravity);
  for (size_t i = 0; i < m_stars.size();)
  {
    Star& p = m_stars[i];
    p.age += seconds;
    if (p.lifespan <= p.age)
    {
      // As the script does: the last star takes this one's place.
      p = m_stars.back();
      m_stars.pop_back();
      continue;
    }
    const float t = p.age / p.lifespan;
    const float spread = p.spreadBirth + (p.spreadDeath - p.spreadBirth) * t;
    float off = p.launchAngle - p.centerAngle;
    while (kPi < off) off -= kTwoPi;
    while (off < -kPi) off += kTwoPi;
    const float heading = p.centerAngle + std::clamp(off, -spread, spread);
    p.vx = std::cos(heading) * p.baseSpeed;
    p.vy = std::sin(heading) * p.baseSpeed + gravity * seconds;
    p.x += p.vx * seconds;
    p.y += p.vy * seconds;
    p.rotation += p.rotSpeed * seconds;
    ++i;
  }
}

void Stars::draw(rive::Renderer* renderer) const
{
  if (m_drawable == nullptr || m_stars.empty() || m_drawable->isHidden())
  {
    return;
  }
  const float opacity = m_drawable->renderOpacity();
  if (opacity <= 0)
  {
    return;
  }
  renderer->save();
  if (opacity < 1)
  {
    renderer->modulateOpacity(opacity);
  }
  renderer->transform(m_drawable->worldTransform());
  for (const Star& p : m_stars)
  {
    const float t = p.age / p.lifespan;
    const float size = p.sizeAtBirth + (p.sizeAtDeath - p.sizeAtBirth) * t;
    const float s = p.scale * size;
    if (s <= 0)
    {
      continue;
    }
    const float c = std::cos(p.rotation);
    const float n = std::sin(p.rotation);
    renderer->save();
    renderer->transform(rive::Mat2D(c * s, n * s, -n * s, c * s, p.x, p.y));
    // The star's own state machine plays its one timeline from birth.
    m_starTimeline->apply(m_star.get(), p.age);
    m_star->draw(renderer);
    renderer->restore();
  }
  renderer->restore();
}

} // namespace taby
