// The stars Taby's wand throws while it works, drawn without a script
// engine. In the character file they are its one Rive script, StarParticles
// (Luau), which the board cannot run: this is that script ported step for
// step (its spawn, advance and draw). The file's animations still drive it
// through the script's own inputs (flowRate, lifespan, speed, ...), and each
// star is the file's starComponent artboard, coloured by its own timeline at
// the star's age, as the script's star instances are.
#pragma once

#include "rive/artboard.hpp"
#include "rive/file.hpp"
#include "rive/renderer.hpp"

#include <cstdint>
#include <memory>
#include <vector>

namespace rive
{
class LinearAnimation;
class ScriptedDrawable;
class ScriptInputNumber;
} // namespace rive

namespace taby
{

class Stars
{
public:
  /** Finds the script's drawable, its inputs and the star artboard; false if
   *  the file has no such script (nothing is drawn then). */
  bool bind(const rive::File& file, rive::ArtboardInstance& artboard);
  bool bound() const { return m_drawable != nullptr; }

  /** The script's advance: new stars at flowRate while `emitting`, and every
   *  star moved on. */
  void advance(float seconds, bool emitting);
  /** The script's draw, where its drawable is, at the drawable's opacity.
   *  Called after the character, inside the character's own transform. */
  void draw(rive::Renderer* renderer) const;
  void clear();
  size_t count() const { return m_stars.size(); }
  void seed(uint32_t value) { m_seed = value; }

private:
  enum Input
  {
    kDirection,
    kFlowRate,
    kLifespan,
    kSpread,
    kVelocity,
    kAngle,
    kGravity,
    kSpeed,
    kSpawnRadius,
    kSizeAtBirth,
    kSizeAtDeath,
    kRotationSpeed,
    kRotationRandom,
    kSpreadAtDeath,
    kEmitterX,
    kEmitterY,
    kInputCount
  };
  struct Star
  {
    float x, y, vx, vy;
    float age, lifespan, scale;
    float sizeAtBirth, sizeAtDeath;
    float rotation, rotSpeed;
    float baseSpeed, launchAngle, centerAngle, spreadBirth, spreadDeath;
  };

  float input(Input which) const;
  /** Lua's math.random(): uniform in [0, 1). */
  float random();
  void spawn();

  rive::ScriptedDrawable* m_drawable = nullptr;
  rive::ScriptInputNumber* m_inputs[kInputCount] = {};
  std::unique_ptr<rive::ArtboardInstance> m_star;
  const rive::LinearAnimation* m_starTimeline = nullptr;
  std::vector<Star> m_stars;
  float m_emitAccum = 0;
  uint32_t m_seed = 0x5eed1234u;
};

} // namespace taby
