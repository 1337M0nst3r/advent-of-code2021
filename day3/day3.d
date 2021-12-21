import std.array;
import std.algorithm;
import std.stdio;
import std.conv;
import std.file;
import std.bitmanip;
import std.range;
import std.string;

struct Column {
  int ones;
  int zeros;
};

const INPUT_FILE = "day3.input";

void main() {
  // Should be 3912944
  assert(part_one() == 3912944);
  writeln("Part one: ", part_one());

  // Should be 
  // assert(part_two() == 0);
  writeln("Part two: ", part_two());
}

int binary_string_to_int(string bstr) {
  int res;
  foreach(i, c; std.array.split(bstr, "")) {
    int bit = to!int(c);
    res = (res << 1) | bit;
  }
  return res;
}

int bitarray_to_int(BitArray ba) {
  int res;
  for(int i = 0; i < ba.length; i++) {
    res = (res << 1) | cast(int)ba[i];
  }
  return res;
}

BitArray str_to_bitarray(string str) {
  auto buff = new bool[str.length];
  buff[0..str.length] = false;
  auto tmp = BitArray(buff);
  foreach(i, c; std.array.split(str, ""))
    if(c == "1") tmp[i] = true;
  return tmp;
}

int part_one() {
  immutable lines = splitLines(readText(INPUT_FILE));

  auto columns = new Column[12];
  foreach(line; lines) {
    uint col_idx = 0;
    foreach(string bit_str; std.array.split(line, "")) {
      if(bit_str == "0")
        columns[col_idx].zeros++;
      else
        columns[col_idx].ones++;
      col_idx++;
    }
  }

  auto gamma_rate_str = join(columns.map!(c => c.ones > c.zeros ? "1" : "0"));
  auto epsilon_rate_str = join(columns.map!(c => c.ones > c.zeros ? "0" : "1"));

  auto gamma_rate = binary_string_to_int(gamma_rate_str);
  auto epsilon_rate = binary_string_to_int(epsilon_rate_str);

  auto power_consumption = gamma_rate * epsilon_rate;

  return power_consumption;
}

int clamp(int n, int max) {
  if(n > max) return max;
  return n;
}

int find_oxygen_generator_rating(BitArray[] nums, Column[] columns, uint bit_idx = 0) {
  bool criteria = columns[bit_idx].zeros == columns[bit_idx].ones || columns[bit_idx].ones > columns[bit_idx].zeros;
  BitArray[] nums_matching_criteria = nums.filter!(n => n[bit_idx] == criteria).array;
  writeln(format("\33[38;5;4mO2\33[0m(%d): %s", bit_idx, nums_matching_criteria[0..clamp(cast(int)nums_matching_criteria.length, 10)]));
  if(nums_matching_criteria.length == 1) {
    return bitarray_to_int(nums_matching_criteria[0]);
  }
  return find_oxygen_generator_rating(nums_matching_criteria, columns, bit_idx + 1);
}

int find_co2_scrubber_rating(BitArray[] nums, Column[] columns, uint bit_idx = 0) {
  bool criteria = columns[bit_idx].ones == columns[bit_idx].zeros ? false : !(columns[bit_idx].ones > columns[bit_idx].zeros);
  BitArray[] nums_matching_criteria = nums.filter!(n => n[bit_idx] == criteria).array;
  writeln(format("CO2(%d): %s", bit_idx, nums_matching_criteria[0..clamp(cast(int)nums_matching_criteria.length, 10)]));
  if(nums_matching_criteria.length == 1) {
    return bitarray_to_int(nums_matching_criteria[0]);
  }
  return find_co2_scrubber_rating(nums_matching_criteria, columns, bit_idx + 1);
}

int part_two() {
  auto lines = splitLines(readText(INPUT_FILE));

  BitArray[] numbers = lines.map!(line => str_to_bitarray(line)).array;
  auto columns = new Column[lines[0].length];
  foreach(line; lines)
    foreach(bit_idx, bit_str; std.array.split(line, ""))
      if(bit_str == "0") columns[bit_idx].zeros++;
      else columns[bit_idx].ones++;

  auto oxygen_generator_rating = find_oxygen_generator_rating(numbers, columns);
  auto co2_scrubber_rating = find_co2_scrubber_rating(numbers, columns);

  auto life_support_rating = oxygen_generator_rating * co2_scrubber_rating;
  return life_support_rating;
}
