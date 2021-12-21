import std.stdio;
import std.file;
import std.format;
import std.conv;
import std.regex;
import std.string;

void main() {
  // should be 1962940
  assert(part_one() == 1962940);
  writeln("Part one: ", part_one());
  // should be 1813664422
  assert(part_two() == 1813664422);
  writeln("Part two: ", part_two());
}

uint part_one() {
  const input_file = "day2.input";
  immutable lines = splitLines(readText(input_file));

  uint hpos, depth;
  foreach(line; lines) {
    auto c = matchFirst(line, regex(`(\S+)\s(\d+)`));
    auto command = c[1];
    auto units = to!uint(c[2]);

    switch(command) {
      case "forward":
        hpos += units;
        break;
      case "down":
        depth += units;
        break;
      case "up":
        depth -= units;
        break;
      default:
        writeln(format("Ignoring unknown command: %s, units: %d", command, units));
    }
  }

  return hpos*depth;
}

int part_two() {
  const input_file = "day2.input";
  immutable lines = splitLines(readText(input_file));

  uint hpos, depth, aim;
  foreach(line; lines) {
    auto c = matchFirst(line, regex(`(\S+)\s(\d+)`));
    auto command = c[1];
    auto units = to!uint(c[2]);

    switch(command) {
      case "forward":
        hpos += units;
        depth += aim * units;
        break;
      case "down":
        aim += units;
        break;
      case "up":
        aim -= units;
        break;
      default:
        writeln(format("Ignoring unknown command: %s, units: %d", command, units));
    }
  }

  return hpos*depth;
}
