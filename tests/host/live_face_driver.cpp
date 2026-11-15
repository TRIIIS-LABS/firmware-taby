// Runs the board's LiveFace (firmware/components/taby_character/taby_face.cpp)
// against the stand-in character in tests/host/live_face/, for
// tests/test_live_face.py.
//
// Reads one command per line and prints JSON lines: the stand-in's own
// events, and one line per frame the face is advanced.
//   show idle|listening|talking     eyes normal|calm|still
//   handover                        takeback
//   fromrest T                      start from rest at T ms
//   gesture NAME                    the app's gesture in the speech from now
//   run FROM TO                     frames at the face's own pace, FROM..TO ms
#include "taby_face.hpp"

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <sstream>
#include <string>

namespace
{
uint32_t s_seed = 7;
uint32_t random32()
{
  s_seed = s_seed * 1664525u + 1013904223u;
  return s_seed >> 4;
}
} // namespace

int main(int argc, char** argv)
{
  if (argc > 1) s_seed = static_cast<uint32_t>(std::strtoul(argv[1], nullptr, 10));
  taby::Character character;
  taby::LiveFace face(character, random32);
  std::string gesture = "idle";
  std::string line;
  while (std::getline(std::cin, line))
  {
    std::istringstream in(line);
    std::string word;
    in >> word;
    if (word == "show")
    {
      in >> word;
      face.show(word == "talking" ? taby::Face::talking
                : word == "listening" ? taby::Face::listening
                                      : taby::Face::idle);
    }
    else if (word == "eyes")
    {
      in >> word;
      face.setEyes(word == "calm" ? taby::Eyes::calm
                   : word == "still" ? taby::Eyes::still
                                     : taby::Eyes::normal);
    }
    else if (word == "handover")
      face.handOver();
    else if (word == "takeback")
      face.takeBack();
    else if (word == "gesture")
      in >> gesture;
    else if (word == "fromrest")
    {
      double at = 0;
      in >> at;
      face.startFromRest(at);
      std::printf("{\"event\":\"fromrest\",\"t\":%.1f,\"atRest\":%s}\n", at,
                  face.atRest(at) ? "true" : "false");
    }
    else if (word == "run")
    {
      double from = 0, to = 0;
      in >> from >> to;
      double last = from;
      for (double now = from; now < to;)
      {
        taby::SpeechFrame speech;
        speech.gesture = gesture;
        const float seconds = static_cast<float>((now - last) / 1000);
        const int blinks = character.blinks();
        const bool moved = face.advance(seconds, now, &speech);
        if (character.blinks() != blinks) std::printf("{\"event\":\"blink\",\"t\":%.1f}\n", now);
        std::printf("{\"frame\":%.1f,\"moved\":%s,\"mode\":\"%s\",\"frameMs\":%.1f,\"atRest\":%s}\n", now,
                    moved ? "true" : "false", taby::modeName(character.mode()), face.frameMs(),
                    face.atRest(now) ? "true" : "false");
        last = now;
        now += face.frameMs();
      }
    }
  }
  return 0;
}
