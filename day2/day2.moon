input_filename = "day2.input"

hpos = 0
depth = 0
aim = 0
for line in io.lines input_filename
  _, _, dir, amount = line\find "(%S+) (%d+)"
  amount = tonumber amount

  switch dir
    when "forward"
      hpos += amount
      depth += aim * amount
    when "up"
      depth -= amount
      aim += amount
    when "down"
      aim += amount
      depth += amount

print string.format("Answer: %d", hpos*depth)

