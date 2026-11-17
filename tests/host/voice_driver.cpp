// Runs the board's VoiceMotion (firmware/components/taby_character/
// taby_voice.cpp) for tests/test_own_talk.py: the app's VOICE_MOTION runs, and
// the mouth the face wears while it talks.
//
// Reads one command per line:
//   line T ARGS        what follows "VOICE_MOTION ", taken at T ms
//   mouth FROM TO S    the mouth every 1000/30 ms from FROM to TO, the face
//                      talking since S ms; one JSON line each
#include "taby_voice.hpp"

#include <cstdio>
#include <iostream>
#include <sstream>
#include <string>

int main()
{
  taby::VoiceMotion voice;
  std::string line;
  while (std::getline(std::cin, line))
  {
    std::istringstream in(line);
    std::string command;
    in >> command;
    if (command == "line")
    {
      double t = 0;
      in >> t;
      std::string args;
      std::getline(in >> std::ws, args);
      std::printf("{\"event\":\"line\",\"t\":%.1f,\"taken\":%s}\n", t, voice.take(args.c_str(), t) ? "true" : "false");
    }
    else if (command == "mouth")
    {
      double from = 0, to = 0, since = 0;
      in >> from >> to >> since;
      for (double t = from; t < to; t += 1000.0 / 30.0)
      {
        const taby::SpeechFrame f = voice.mouth(t, since);
        std::printf("{\"t\":%.1f,\"viseme\":\"%s\",\"jaw\":%.1f,\"expression\":\"%s\"}\n", t, f.viseme.c_str(),
                    f.jawOpen, f.expression.c_str());
      }
    }
  }
  return 0;
}
