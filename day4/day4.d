import std.algorithm;
import std.array;
import std.bitmanip;
import std.conv;
import std.file;
import std.range;
import std.regex;
import std.stdio;
import std.string;
import std.typecons;

const INPUT_FILE = "day4.input";

void main() {
  auto answers = part_one_and_two();
  assert(answers[0] == 35711, format("The answer for part one should be 35711 but it is: %d", answers[0]));
  writeln("Part one: ", answers[0]);

  assert(answers[1] == 5586, format("The answer for part one should be 5586 but it is: %d", answers[1]));
  writeln("Part two: ", answers[1]);
}

alias Row = Typedef!int[5];

struct BingoBoard {
  Row[] data;
  bool has_won = false;
  int[] matched_numbers;
};

struct BingoGameState {
  BingoBoard[] winned_boards;
  BingoBoard[] losed_boards;
  int          current_number_idx;
};

bool is_winning_row(Row row, int[] matched_numbers) {
  foreach(n; row)
    if(!canFind(matched_numbers, n)) return false;
  return true;
}

bool is_winning_column(int col_idx, BingoBoard board) {
  int[] column = board.data.map!(row => to!int(row[col_idx])).array;
  foreach(n; column)
    if(!canFind(board.matched_numbers, n)) return false;
  return true;
}

bool has_number(BingoBoard board, int n) {
  foreach(row; board.data)
    if(canFind(cast(int[])(row), n)) return true;
  return false;
}

bool has_won(BingoBoard board) {
  if(board.matched_numbers.length < 5) return false;
  foreach(row; board.data)
    if(is_winning_row(row, board.matched_numbers)) return true;
  foreach(col_idx; 0..5)
    if(is_winning_column(col_idx, board)) return true;
  return false;
}

int[] get_unmatched_numbers(BingoBoard board) {
  int[] unmatched_numbers;
  foreach(row; board.data)
    foreach(n; row)
      if(!canFind(board.matched_numbers, n)) unmatched_numbers ~= to!int(n);
  return unmatched_numbers;
}

int[] part_one_and_two() {
  auto lines = splitLines(readText(INPUT_FILE));
  int[] winning_numbers = std.array.split(lines[0], ",").map!(n => to!int(n)).array;

  lines = lines.filter!(line => !matchFirst(line, regex(`(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)`)).empty).array;

  int[5][] parsed_lines;
  foreach(i, line; lines) {
    int[5] parsed_line = std.array.split(line).map!(e => to!int(strip(e))).array;
    parsed_lines ~= parsed_line;
  }

  BingoBoard[] bingo_boards;
  for(int i = 0; i < parsed_lines.length; i += 5) {
    BingoBoard board = { data: parsed_lines[i..(i+5)].map!(pl => cast(Row)pl).array };
    bingo_boards ~= board;
  }

  BingoGameState game_state;
  while(game_state.current_number_idx < winning_numbers.length) {
    int current_number = winning_numbers[game_state.current_number_idx];
    foreach(ref board; bingo_boards) {
      if(board.has_won) continue;
      if(has_number(board, current_number)) board.matched_numbers ~= current_number;
      if(board.matched_numbers.length >= 5 && has_won(board)) {
        board.has_won = true;
        game_state.winned_boards ~= board;
      }
    }
    game_state.current_number_idx++;
  }

  auto first_winning_board = game_state.winned_boards[0];
  auto last_winning_board = game_state.winned_boards[$-1];

  auto part_one_answer = get_unmatched_numbers(first_winning_board).reduce!( (a,b) => a + b) * first_winning_board.matched_numbers[$-1];
  auto part_two_answer = get_unmatched_numbers(last_winning_board).reduce!( (a,b) => a + b) * last_winning_board.matched_numbers[$-1];
  return [part_one_answer, part_two_answer];
}
