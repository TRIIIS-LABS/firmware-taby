// The notch's Taby character, driven the way the desktop notch drives it.
//
// A C++ port of apps/desktop/src/renderer/notch/character-state.ts and
// character-action.ts in app-taby: the same ViewModel properties, the same
// mode resets, and the same exit handoff for the authored actions (idle loop,
// listening, processing), which own the whole face until `exitAction` lands.
#pragma once

#include "rive/animation/state_machine_instance.hpp"
#include "rive/artboard.hpp"
#include "rive/file.hpp"
#include "rive/viewmodel/runtime/viewmodel_instance_runtime.hpp"

#include <memory>
#include <string>
#include <vector>

namespace rive
{
class ScriptedDrawable;
class ScriptInputNumber;
} // namespace rive

namespace taby
{

/** One frame of the app's speech motion (speech-motion.ts SpeechMotionFrame). */
struct SpeechFrame
{
  std::string viseme = "sil";
  float jawOpen = 0;
  std::string gesture = "idle";
  /** "happy" | "serious" | "idle" | "closeEye", as the app names them. */
  std::string expression = "idle";
};

/** A pose of the rig's own layers, as the asset names them: what a clip's
 *  first or last frame looks like on the live character, so a handoff can
 *  move the character's parts into it (or out of it) and cut there. */
struct Pose
{
  std::string expression = "idle";  // idle | closeEye | unconfident | serious
  std::string gesture = "idle";
  std::string viseme = "sil";
  float jawOpen = 0;
  bool eyebrow = false;
  std::string accessory = "none";
};

enum class Mode
{
  idle,
  working,
  listening,
  ready,
  speaking,
  /** The asset's neutral face, held still: what clips start from. */
  rest,
};

const char* modeName(Mode mode);
bool parseMode(const std::string& text, Mode* mode);

/** The authored-action handoff from character-action.ts. */
class CharacterAction
{
public:
  using Trigger = void (*)(void* context, const char* name);
  CharacterAction(Trigger trigger, void* context) :
      m_trigger(trigger), m_context(context)
  {}

  bool isExiting() const { return m_phase != Phase::settled; }
  /** How long the face has been settled at rest; 0 if it is not. */
  double restingMs(double nowMs) const
  {
    return m_desired == Mode::rest && m_phase == Phase::settled ? nowMs - m_phaseSince : 0;
  }
  bool allowsTalkingFace() const
  {
    return m_phase == Phase::settled || m_phase == Phase::lead ||
           m_phase == Phase::fired;
  }
  void request(Mode mode, double nowMs, double holdMs = 0);
  void observe(const std::vector<std::string>& states, double nowMs);
  void advance(double nowMs);

private:
  enum class Phase
  {
    settled,
    waiting,
    lead,
    fired,
    insist
  };
  void enter(Phase phase, double nowMs);
  void start();
  bool consumable(double nowMs) const;

  Trigger m_trigger;
  void* m_context;
  Mode m_desired = Mode::idle;
  Phase m_phase = Phase::settled;
  double m_phaseSince = 0;
  bool m_startPending = false;
  double m_startNotBefore = 0;
  std::string m_authored;
  double m_authoredSince = 0;
  double m_requestedAt = 0;
};

class Character
{
public:
  Character();
  ~Character();

  /** Loads the .riv; on failure `error` says what was missing. */
  bool load(rive::Span<const uint8_t> riv,
            rive::Factory* factory,
            std::string* error);

  void setMode(Mode mode, double nowMs);
  Mode mode() const { return m_mode; }
  /** One mouth frame while speaking: an authored viseme and 0..100 jaw. */
  void setMouth(const char* viseme, float jawOpen);
  /** One speech frame, applied as the notch applies it
   *  (character-state.ts applyTabyCharacterSpeech). */
  void applySpeech(const SpeechFrame& frame, double nowMs);
  /** Device: the working stars fade out quickly and are cleared once
   *  working ends (on by default; the app lets them fall). */
  void setStarsQuickExit(bool on) { m_starsQuickExit = on; }
  /** False while an authored action still covers the gesture layers. */
  bool layersFree() const { return !m_action.isExiting(); }
  double restingMs(double nowMs) const { return m_action.restingMs(nowMs); }
  void setGesture(const char* gesture);
  /** Holds a pose while the character rests (Mode::rest): the rig's layers
   *  blend into it. Null lets go, and the layers blend back. */
  void holdPose(const Pose* pose);
  bool holdsPose() const { return m_holding; }
  void blink();
  /** Fires a ViewModel trigger by name (a clip: "clipBlush"); false if the
   *  file has no such trigger. */
  bool trigger(const char* name);

  /** Advances the state machine; returns the names of states it entered. */
  std::vector<std::string> advance(float seconds, double nowMs);
  /** `extra`: an artboard-space transform (a clip's framing); `opacity`
   *  fades the whole character. */
  void draw(rive::Renderer* renderer, float width, float height,
            const rive::Mat2D& extra = rive::Mat2D(), float opacity = 1.0f);

  rive::AABB bounds() const;
  const std::vector<std::string>& visemes() const { return m_visemes; }
  const std::vector<std::string>& gestures() const { return m_gestures; }
  const std::vector<std::string>& expressions() const
  {
    return m_expressions;
  }

private:
  static void fire(void* context, const char* name);
  void resetMouth();
  void resetFace();
  void syncReadyFace();
  void setEnum(rive::ViewModelInstanceEnumRuntime* port, const char* value);
  void advanceStars(float seconds, double nowMs);

  rive::rcp<rive::File> m_file;
  // The artboard's own rectangle: while a blink squashes the character,
  // what lies outside it (hands waiting out of frame) stays hidden.
  rive::rcp<rive::RenderPath> m_frame;
  std::unique_ptr<rive::ArtboardInstance> m_artboard;
  std::unique_ptr<rive::StateMachineInstance> m_machine;
  rive::rcp<rive::ViewModelInstanceRuntime> m_vm;
  CharacterAction m_action;
  Mode m_mode = Mode::idle;

  rive::ViewModelInstanceEnumRuntime* m_viseme = nullptr;
  rive::ViewModelInstanceEnumRuntime* m_gesture = nullptr;
  rive::ViewModelInstanceEnumRuntime* m_expression = nullptr;
  rive::ViewModelInstanceEnumRuntime* m_accessory = nullptr;
  rive::ViewModelInstanceBooleanRuntime* m_eyebrow = nullptr;
  rive::ViewModelInstanceNumberRuntime* m_jaw = nullptr;
  std::vector<std::string> m_visemes;
  std::vector<std::string> m_gestures;
  std::vector<std::string> m_expressions;
  double m_gestureReleasedAt = -1e9;
  bool m_holding = false;

  // The working sparkle (the file's StarParticles script). On the board its
  // stars cost most of a frame, and after working they kept falling under the
  // talking face at 11 fps; here they fade out quickly once working ends and
  // are then cleared in one step.
  rive::ScriptedDrawable* m_stars = nullptr;
  rive::ScriptInputNumber* m_flowRate = nullptr;
  float m_starsOpacity = 1.0f;
  bool m_starsCleared = true;
  bool m_starsQuickExit = true;
};

} // namespace taby
