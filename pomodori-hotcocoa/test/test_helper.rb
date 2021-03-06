Dir[File.dirname(__FILE__) + "/../vendor/**/lib"].each do |dir|
  $LOAD_PATH.unshift dir unless $LOAD_PATH.include?(dir)
end

require "mocha"
require "matchy"
require "test/unit"
require "microspec"
require File.dirname(__FILE__) + '/../lib/pomodori'
require "pomodori/extensions/timestamp"

def wipe_dir(dir, regex = /.tbl/)
  Dir.entries(dir).each do |name|
    path = File.join(dir, name)
    if name =~ regex
      ftype = File.directory?(path) ? Dir : File
      begin
        ftype.delete(path)
      rescue SystemCallError => e
        $stderr.puts e.message
      end
    end
  end
end

def pomodoros(how_many = 10)
  require 'pomodori/models/pomodoro'
  pomos = []
  how_many.times do |i|
    pomos << Pomodoro.new(
      :text => "Pomo#{i}",
      :timestamp => "2009-03-0#{i % 3 + 1} 01:01:01 -0500")
  end
  pomos
end

##
# 3, 6, 9 pomos a day
# average 6+9/2=7
#
def pomodoro_count_by_day_sample
  pomos = []
  3.times do |i|
    pomos << PomodoroCountByDay.new(DateTime.new(2009, 03, i % 3 + 1), pomodoros(3 * (i + 1)))
  end
  pomos
end
