#include "taby_character.hpp"

#include "rive/animation/animation_state.hpp"
#include "rive/animation/any_state.hpp"
#include "rive/animation/entry_state.hpp"
#include "rive/animation/exit_state.hpp"
#include "rive/animation/linear_animation.hpp"
#include "rive/renderer.hpp"
#include "rive/script_input_number.hpp"
#include "rive/scripted/scripted_drawable.hpp"
#include "rive/viewmodel/runtime/viewmodel_runtime.hpp"

#include <algorithm>
#include <cstring>

namespace taby
{
namespace
{

// character-action.ts
constexpr double kFaceLeadMs = 300;
constexpr double kExitPatienceMs = 1800;
constexpr double kUnreportedWaitMs = 350;
// character-state.ts
constexpr double kGestureReleaseMs = 300;
constexpr int kOpeningBlendSteps = 16;
constexpr float kOpeningBlendStepSeconds = 0.05f;
// Device only: how quickly the working stars go once working ends.
constexpr double kStarsFadeMs = 150;

/** Authored action states and when each can consume `exitAction`. */
struct Settle
{
  const char* name;
  double ms; // < 0: the state has no exit of its own
};
constexpr Settle kSettle[] = {
    {"idle loop", 350},
    {"hearing", 150},
    {"prossesingtwo", 350},
    {"prossesingFirst", -1},
};

const Settle* settleFor(const std::string& name)
{
  for (const auto& entry : kSettle)
  {
    if (name == entry.name)
    {
      return &entry;
    }
  }
  return nullptr;
}

bool exited(Mode mode)
{
  return mode == Mode::speaking || mode == Mode::ready || mode == Mode::rest;
}
// Actions that take over from another action without an exit: `exitAction`
// takes the action to the asset's neutral "idle" state (which resets what it
// drew), and the next one starts once that blend is over, instead of holding
// a still face until the asset reports its exit most of a second later.
bool busy(Mode mode) { return mode == Mode::working || mode == Mode::listening; }
constexpr double kNeutralBlendMs = 300;

std::string stateName(const rive::LayerState* state)
{
  if (state == nullptr)
  {
    return "unknown";
  }
  if (state->is<rive::AnimationState>())
  {
    auto* animation = state->as<rive::AnimationState>()->animation();
    return animation != nullptr ? animation->name() : "unknown";
  }
  if (state->is<rive::ExitState>())
  {
    return "exit";
  }
  if (state->is<rive::EntryState>())
  {
    return "entry";
  }
  if (state->is<rive::AnyState>())
  {
    return "any";
  }
  return "unknown";
}

} // namespace

const char* modeName(Mode mode)
{
  switch (mode)
  {
    case Mode::idle:
      return "idle";
    case Mode::working:
      return "working";
    case Mode::listening:
      return "listening";
    case Mode::ready:
      return "ready";
    case Mode::speaking:
      return "speaking";
    case Mode::rest:
      return "rest";
  }
  return "idle";
}

bool parseMode(const std::string& text, Mode* mode)
{
  for (Mode m : {Mode::idle,
                 Mode::working,
                 Mode::listening,
                 Mode::ready,
                 Mode::speaking,
                 Mode::rest})
  {
    if (text == modeName(m))
    {
      *mode = m;
      return true;
    }
  }
  return false;
}

// ---- CharacterAction ----

void CharacterAction::request(Mode mode, double now, double holdMs)
{
  if (mode == m_desired)
  {
    return;
  }
  const Mode previous = m_desired;
  m_desired = mode;
  if (isExiting())
  {
    return;
  }
  // A start still held back never happened: nothing to exit.
  const bool free = exited(previous) || m_startPending;
  if (free && exited(mode))
  {
    m_startPending = false;
    return;
  }
  // From one authored action to another (resting, listening, working) the
  // next takes over at once and the layer blends one into the other, with no
  // stop on the neutral face between (Peter, 2026-11-15, of listening into
  // working: "it needs to be like ... from idle"; of working back to idle:
  // "it seems to lag a little").
  const bool straight = !exited(mode) && !exited(previous);
  if (free || straight)
  {
    const double running = m_startPending ? m_startNotBefore : 0;
    const double notBefore = std::max(now + holdMs, running);
    if (notBefore <= now)
    {
      start();
    }
    else
    {
      m_startPending = true;
      m_startNotBefore = notBefore;
    }
  }
  else
  {
    m_requestedAt = now;
    enter(Phase::waiting, now);
    advance(now);
  }
}

void CharacterAction::observe(const std::vector<std::string>& states,
                              double now)
{
  bool sawExit = false;
  bool sawNeutral = false;
  for (const auto& name : states)
  {
    if (settleFor(name) != nullptr)
    {
      m_authored = name;
      m_authoredSince = now;
    }
    sawExit = sawExit || name == "exit";
    sawNeutral = sawNeutral || name == "idle";
  }
  if (!isExiting())
  {
    return;
  }
  if (sawExit)
  {
    enter(Phase::settled, now);
    m_authored.clear();
    m_startPending = true;
    m_startNotBefore = 0;
  }
  else if (sawNeutral && (busy(m_desired) || m_desired == Mode::rest) &&
           (m_phase == Phase::fired || m_phase == Phase::insist))
  {
    enter(Phase::settled, now);
    m_authored.clear();
    m_startPending = true;
    m_startNotBefore = now + kNeutralBlendMs;
  }
}

void CharacterAction::advance(double now)
{
  switch (m_phase)
  {
    case Phase::waiting:
      if (consumable(now))
      {
        if (busy(m_desired) || m_desired == Mode::rest)
        {
          // Another action follows, or none: no talking face to put on first.
          enter(Phase::fired, now);
          m_trigger(m_context, "exitAction");
        }
        else
        {
          enter(Phase::lead, now);
        }
      }
      break;
    case Phase::lead:
      if (now - m_phaseSince >= kFaceLeadMs)
      {
        enter(Phase::fired, now);
        m_trigger(m_context, "exitAction");
      }
      break;
    case Phase::fired:
      if (now - m_phaseSince >= kExitPatienceMs)
      {
        enter(Phase::insist, now);
      }
      break;
    case Phase::insist:
      m_trigger(m_context, "exitAction");
      break;
    case Phase::settled:
      if (m_startPending && now >= m_startNotBefore)
      {
        start();
      }
      break;
  }
}

bool CharacterAction::consumable(double now) const
{
  if (m_authored.empty())
  {
    return now - m_requestedAt >= kUnreportedWaitMs;
  }
  const Settle* settle = settleFor(m_authored);
  return settle != nullptr && settle->ms >= 0 &&
         now - m_authoredSince >= settle->ms;
}

void CharacterAction::enter(Phase phase, double now)
{
  m_phase = phase;
  m_phaseSince = now;
}

void CharacterAction::start()
{
  m_startPending = false;
  if (m_desired == Mode::idle)
  {
    m_trigger(m_context, "idleLoop");
  }
  else if (m_desired == Mode::working)
  {
    m_trigger(m_context, "isProcessing");
  }
  else if (m_desired == Mode::listening)
  {
    m_trigger(m_context, "isListening");
  }
}

// ---- Character ----

Character::Character() : m_action(&Character::fire, this) {}

Character::~Character() = default;

void Character::fire(void* context, const char* name)
{
  auto* self = static_cast<Character*>(context);
  if (auto* trigger = self->m_vm->propertyTrigger(name))
  {
    trigger->trigger();
  }
}

bool Character::load(rive::Span<const uint8_t> riv,
                     rive::Factory* factory,
                     std::string* error)
{
  rive::ImportResult result;
  m_file = rive::File::import(riv, factory, &result);
  if (m_file == nullptr)
  {
    *error = "the .riv did not import (result " +
             std::to_string(static_cast<int>(result)) + ")";
    return false;
  }
  m_artboard = m_file->artboardNamed("Artboard");
  if (m_artboard == nullptr)
  {
    m_artboard = m_file->artboardDefault();
  }
  if (m_artboard == nullptr)
  {
    *error = "no artboard";
    return false;
  }
  m_frame = factory->makeRenderPath(m_artboard->bounds());
  m_machine = m_artboard->stateMachineNamed("StateMachine");
  if (m_machine == nullptr)
  {
    m_machine = m_artboard->defaultStateMachine();
  }
  if (m_machine == nullptr)
  {
    *error = "no state machine";
    return false;
  }
  rive::ViewModelRuntime* viewModel = m_file->viewModelByName("ViewModel");
  if (viewModel == nullptr)
  {
    viewModel = m_file->defaultArtboardViewModel(m_artboard.get());
  }
  if (viewModel == nullptr)
  {
    *error = "no ViewModel";
    return false;
  }
  m_vm = viewModel->createDefaultInstance();
  if (m_vm == nullptr)
  {
    m_vm = viewModel->createInstance();
  }
  m_viseme = m_vm->propertyEnum("enumViseme");
  m_gesture = m_vm->propertyEnum("enumGesture");
  m_expression = m_vm->propertyEnum("enumExpression");
  m_accessory = m_vm->propertyEnum("enumAccessories");
  m_eyebrow = m_vm->propertyBoolean("isEyebrowOn");
  m_jaw = m_vm->propertyNumber("jawOpen");
  std::string missing;
  if (m_viseme == nullptr) missing += " enumViseme";
  if (m_gesture == nullptr) missing += " enumGesture";
  if (m_expression == nullptr) missing += " enumExpression";
  if (m_accessory == nullptr) missing += " enumAccessories";
  if (m_eyebrow == nullptr) missing += " isEyebrowOn";
  if (m_jaw == nullptr) missing += " jawOpen";
  for (const char* trigger :
       {"idleLoop", "blink", "isListening", "isProcessing", "exitAction"})
  {
    if (m_vm->propertyTrigger(trigger) == nullptr)
    {
      missing += std::string(" ") + trigger;
    }
  }
  if (!missing.empty())
  {
    *error = "ViewModel lacks" + missing;
    return false;
  }
  m_visemes = m_viseme->values();
  m_gestures = m_gesture->values();
  m_expressions = m_expression->values();
  m_machine->bindViewModelInstance(m_vm->instance());
  for (rive::Core* object : m_artboard->objects())
  {
    if (object == nullptr) continue;
    if (m_stars == nullptr && object->is<rive::ScriptedDrawable>())
    {
      m_stars = object->as<rive::ScriptedDrawable>();
    }
    else if (m_flowRate == nullptr && object->is<rive::ScriptInputNumber>() &&
             object->as<rive::ScriptInputNumber>()->name() == "flowRate")
    {
      m_flowRate = object->as<rive::ScriptInputNumber>();
    }
  }

#ifndef WITH_RIVE_SCRIPTING
  m_native.bind(*m_file, *m_artboard);
#endif

  // bindTabyCharacterModel: reset, leave any action, start the idle loop,
  // and run the opening blends before the first frame is drawn.
  resetFace();
  fire(this, "exitAction");
  fire(this, "idleLoop");
  m_mode = Mode::idle;
  for (int step = 0; step < kOpeningBlendSteps; ++step)
  {
    m_machine->advanceAndApply(kOpeningBlendStepSeconds);
  }
  return true;
}

void Character::setEnum(rive::ViewModelInstanceEnumRuntime* port,
                        const char* value)
{
  if (port->value() != value)
  {
    port->value(value);
  }
}

void Character::resetMouth()
{
  setEnum(m_viseme, "sil");
  m_jaw->value(0);
}

void Character::resetFace()
{
  resetMouth();
  setEnum(m_gesture, "idle");
  setEnum(m_expression, "idle");
  setEnum(m_accessory, "none");
  m_eyebrow->value(false);
}

void Character::setMode(Mode mode, double now)
{
  if (mode == m_mode)
  {
    return;
  }
  m_mode = mode;
  // The speech loop usually drops the gesture a moment before the mode
  // changes, so what counts is when its release began, not its value.
  const double release =
      m_gesture->value() != "idle"
          ? kGestureReleaseMs
          : std::max(0.0, kGestureReleaseMs - (now - m_gestureReleasedAt));
  if (mode == Mode::speaking)
  {
    resetMouth();
  }
  else
  {
    resetFace();
  }
  m_holding = false;
  // Listening is the one authored action drawn with its eyebrows.
  if (mode == Mode::listening)
  {
    m_eyebrow->value(true);
  }
  m_action.request(mode, now, release);
  syncReadyFace();
}

void Character::syncReadyFace()
{
  if (m_mode != Mode::ready)
  {
    return;
  }
  if (!m_action.allowsTalkingFace())
  {
    setEnum(m_expression, "idle");
    m_eyebrow->value(false);
    return;
  }
  // The export calls its happy face `unconfident`.
  setEnum(m_expression, "unconfident");
  m_eyebrow->value(false);
}

void Character::setMouth(const char* viseme, float jawOpen)
{
  if (std::find(m_visemes.begin(), m_visemes.end(), viseme) !=
      m_visemes.end())
  {
    setEnum(m_viseme, viseme);
  }
  m_jaw->value(std::max(0.0f, std::min(100.0f, jawOpen)));
  setEnum(m_expression,
          m_action.allowsTalkingFace() ? "unconfident" : "idle");
  const std::string gesture = m_gesture->value();
  m_eyebrow->value(!m_action.isExiting() && gesture != "idle" &&
                   gesture != "shrug");
}

void Character::applySpeech(const SpeechFrame& frame, double now)
{
  const bool exiting = m_action.isExiting();
  // The export calls its happy face `unconfident`.
  const std::string authored =
      frame.expression == "happy" ? "unconfident" : frame.expression;
  const std::string expression =
      !m_action.allowsTalkingFace() ? "idle" : authored;
  if (std::find(m_visemes.begin(), m_visemes.end(), frame.viseme) !=
      m_visemes.end())
  {
    setEnum(m_viseme, frame.viseme.c_str());
  }
  m_jaw->value(std::max(0.0f, std::min(100.0f, frame.jawOpen)));
  const bool known = std::find(m_gestures.begin(), m_gestures.end(),
                               frame.gesture) != m_gestures.end();
  const std::string gesture = known ? frame.gesture : "idle";
  if (gesture == "idle" && m_gesture->value() != "idle")
  {
    m_gestureReleasedAt = now;
  }
  setEnum(m_gesture, gesture.c_str());
  const bool knownFace = std::find(m_expressions.begin(), m_expressions.end(),
                                   expression) != m_expressions.end();
  setEnum(m_expression, knownFace ? expression.c_str() : "idle");
  // Brows ride the gestures (not a shrug); serious is drawn around them.
  m_eyebrow->value(!exiting &&
                   ((gesture != "idle" && gesture != "shrug") ||
                    m_expression->value() == "serious"));
}

void Character::setGesture(const char* gesture)
{
  if (std::find(m_gestures.begin(), m_gestures.end(), gesture) !=
      m_gestures.end())
  {
    setEnum(m_gesture, gesture);
  }
}

void Character::holdPose(const Pose* pose)
{
  if (pose == nullptr)
  {
    if (m_holding)
    {
      m_holding = false;
      if (m_gesture->value() != "idle")
      {
        m_gestureReleasedAt = -1e9;
      }
      resetFace();
    }
    return;
  }
  m_holding = true;
  auto pick = [](const std::vector<std::string>& values, const std::string& v,
                 const char* fallback) {
    return std::find(values.begin(), values.end(), v) != values.end()
               ? v.c_str()
               : fallback;
  };
  setEnum(m_expression, pick(m_expressions, pose->expression, "idle"));
  setEnum(m_gesture, pick(m_gestures, pose->gesture, "idle"));
  setEnum(m_viseme, pick(m_visemes, pose->viseme, "sil"));
  setEnum(m_accessory, pose->accessory.c_str());
  m_jaw->value(std::max(0.0f, std::min(100.0f, pose->jawOpen)));
  m_eyebrow->value(pose->eyebrow);
}

void Character::blink() { fire(this, "blink"); }

bool Character::trigger(const char* name)
{
  auto* port = m_vm->propertyTrigger(name);
  if (port == nullptr)
  {
    return false;
  }
  port->trigger();
  return true;
}

void Character::advanceStars(float seconds, double now)
{
  if (m_stars == nullptr || !m_starsQuickExit)
  {
    return;
  }
  // The stars go with the wand: they keep coming while it swings, until the
  // working action lets go of the face.
  if (m_mode == Mode::working || m_action.working())
  {
    m_starsOpacity = 1.0f;
    m_starsCleared = false;
    m_native.advance(seconds, true);
  }
  else if (!m_starsCleared)
  {
    m_native.advance(seconds, false);
    m_starsOpacity = std::max(0.0f, m_starsOpacity - float(seconds * 1000 / kStarsFadeMs));
    if (m_starsOpacity <= 0.0f)
    {
      // Every star is out of sight: let them all live out their lives in one
      // step with the emitter off, so none is left to simulate.
      const float flow = m_flowRate != nullptr ? m_flowRate->propertyValue() : 0;
      if (m_flowRate != nullptr) m_flowRate->propertyValue(0);
      m_stars->advanceComponent(30.0f,
                                rive::AdvanceFlags::AdvanceNested | rive::AdvanceFlags::NewFrame |
                                    rive::AdvanceFlags::Animate);
      if (m_flowRate != nullptr) m_flowRate->propertyValue(flow);
      m_native.clear();
      m_starsCleared = true;
    }
  }
  if (m_stars->opacity() != m_starsOpacity)
  {
    m_stars->opacity(m_starsOpacity);
  }
}

std::vector<std::string> Character::advance(float seconds, double now)
{
  advanceStars(seconds, now);
  m_moving = m_machine->advanceAndApply(seconds) || m_native.count() > 0;
  std::vector<std::string> entered;
  const size_t count = m_machine->stateChangedCount();
  for (size_t i = 0; i < count; ++i)
  {
    entered.push_back(stateName(m_machine->stateChangedByIndex(i)));
  }
  if (!entered.empty())
  {
    m_action.observe(entered, now);
  }
  m_action.advance(now);
  syncReadyFace();
  return entered;
}

void Character::draw(rive::Renderer* renderer, float width, float height,
                     const rive::Mat2D& extra, float opacity)
{
  if (opacity <= 0.0f)
  {
    return;
  }
  renderer->save();
  if (opacity < 1.0f)
  {
    renderer->modulateOpacity(opacity);
  }
  renderer->align(rive::Fit::contain,
                  rive::Alignment::center,
                  rive::AABB(0, 0, width, height),
                  m_artboard->bounds());
  renderer->transform(extra);
  if (extra != rive::Mat2D() && m_frame != nullptr)
  {
    renderer->clipPath(m_frame.get());
  }
  m_artboard->draw(renderer);
  // The script's drawable sits above the face, hat and hands.
  m_native.draw(renderer);
  renderer->restore();
}

rive::AABB Character::bounds() const { return m_artboard->bounds(); }

} // namespace taby
