import std.stdio;
import std.file;
import std.format;
import std.conv;
import std.string;

void main() {
  // should be 1502
  writeln("Part one: ", part_one());

  // should be 1538
  writeln("Part two: ", part_two());
}

int part_one() {
  const input_file = "day1.input";
  immutable lines = splitLines(readText(input_file));

  uint previous_measurement, increase_count;
  foreach(string line; lines) {
    uint measurement = to!uint(line);
    if (previous_measurement != 0 && measurement > previous_measurement)
      increase_count++;
    previous_measurement = measurement;
  }
  return increase_count;
}

int part_two() {
  const input_file = "day1.input";
  const window_length = 3;
  immutable lines = splitLines(readText(input_file));

  uint previous_sum, increase_count;
  for(int i = 0; i <= lines.length - window_length; i++) {
    auto current_sum = to!uint(lines[i]) + to!uint(lines[i+1]) + to!uint(lines[i+2]);
    if (previous_sum != 0 && current_sum > previous_sum)
      increase_count++;
    previous_sum = current_sum;
  }

  return increase_count;
}
