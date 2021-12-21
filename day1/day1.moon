input_filename = "day1.input"

part_one = ->
  local previous_measurement
  increase_count = 0
  for measurement in io.lines input_filename
    measurement = tonumber measurement
    if previous_measurement and measurement > previous_measurement
      increase_count += 1
    previous_measurement = measurement
  return increase_count

print "Part one: ", part_one!
