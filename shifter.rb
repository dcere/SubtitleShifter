# Description:
#   Shifts the times in a SubRip file (.srt file)
#
# Synopsis:
#   shifter.rb <input-file> <shift>
#
# Arguments:
#   - Input file: The input file you want to shift.
#   - Shift: The amount in milliseconds the file will be shifted.
#
# Examples:
#   _$: ruby shifter.rb test.srt 2500
#   _$: ruby shifter.rb test.srt -2500
#
#
# Author:
#   David Ceresuela


# SubRip format
#
# According to wikipedia this is the format of SubRip (.srt) files
#  1
#  00:00:20,000 --> 00:00:24,400
#  Altocumulus clouds occur between six thousand

#  2
#  00:00:24,600 --> 00:00:27,800
#  and twenty thousand feet above ground level.
#
# where the time follows the hours:minutes:seconds,milliseconds format.

class MyTime

  @@regex = /([0-9]{2}):([0-9]{2}):([0-9]{2}),([0-9]{3})/
  @@h_ms = 3600000  # An hour is 3600000 milliseconds
  @@m_ms = 60000    # A minute is 60000 milliseconds
  @@s_ms = 1000     # A second is 1000 milliseconds


  def initialize(time)
    match = @@regex.match(time)
    @hour = match[1].to_i
    @minute = match[2].to_i
    @second = match[3].to_i
    @millisecond = match[4].to_i
  end
  
  
  def to_ms
    (@hour * @@h_ms) + (@minute * @@m_ms) + (@second * @@s_ms) + @millisecond
  end
  
  
  def to_time(milliseconds)
    m = milliseconds
    
    @hour = m / @@h_ms
    m = m - (@hour * @@h_ms)
    
    @minute = m / @@m_ms
    m = m  - (@minute * @@m_ms)
    
    @second = m / @@s_ms
    m = m - (@second * @@s_ms)
    
    @millisecond = m
  end
  
  
  def to_s
    format("%02i:%02i:%02i,%03i", @hour, @minute, @second, @millisecond)
  end
  
  def add(time)
    # Adds <time> milliseconds to a time
    self.to_time(self.to_ms + time)
  end
  
  
  def sub(time)
    # Substracts <time> milliseconds from a time
    self.to_time(self.to_ms - time)
  end

end




regex = /^([0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}) --> ([0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3})/

# Open files
input_file_name = ARGV[0]
output_file_name = input_file_name + "(shifted)"

input_file = File.open(input_file_name, "r")
output_file = File.open(output_file_name, "w")

# Get the shift
shift = ARGV[1].to_i

# Shift the file
input_file.each do |line|
  match = regex.match(line)
  if match
    time1 = MyTime.new(match[1])
    time2 = MyTime.new(match[2])
    time1.add(shift)
    time2.add(shift)
    output_file.write(time1.to_s + " --> " + time2.to_s + "\n")
  else
    output_file.write(line)  
  end
end

# Close files
input_file.close()
output_file.close()
