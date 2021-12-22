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
  assert(part_one() == 3912944, "Part one should be 3912944");
  writeln("Part one: ", part_one());

  assert(part_two() == 4996233, "Part two should be 4996233");
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

Column get_bit_stats(BitArray[] numbers, int bit_idx) {
  Column stats;
  foreach(n; numbers)
    if(n[bit_idx] == 1) stats.ones++;
    else stats.zeros++;
  return stats;
}

BitArray find_bit_by_criteria(BitArray[] nums, bool delegate(Column) criteria, uint bit_idx = 0) {
  auto bit_stats = get_bit_stats(nums, bit_idx);
  BitArray[] nums_matching_criteria = nums.filter!(n => n[bit_idx] == criteria(bit_stats)).array;
  if(nums_matching_criteria.length == 1)
    return nums_matching_criteria[0];
  return find_bit_by_criteria(nums_matching_criteria, criteria, bit_idx + 1);
}

int find_oxygen_generator_rating(BitArray[] nums) {
  return bitarray_to_int(find_bit_by_criteria(nums, (bit_stats) {
    return (bit_stats.zeros == bit_stats.ones || bit_stats.ones > bit_stats.zeros);
  }));
}

int find_co2_scrubber_rating(BitArray[] nums) {
  return bitarray_to_int(find_bit_by_criteria(nums, (bit_stats) {
    return (bit_stats.ones == bit_stats.zeros ? false : !(bit_stats.ones > bit_stats.zeros));
  }));
}

int part_two() {
  auto lines = splitLines(readText(INPUT_FILE));

  BitArray[] numbers = lines.map!(line => str_to_bitarray(line)).array;
  auto oxygen_generator_rating = find_oxygen_generator_rating(numbers);
  auto co2_scrubber_rating = find_co2_scrubber_rating(numbers);

  auto life_support_rating = oxygen_generator_rating * co2_scrubber_rating;
  return life_support_rating;
}
