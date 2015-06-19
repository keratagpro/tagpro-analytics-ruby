if ARGV.length < 1
	puts "Usage: #{File.basename($0)} <filename>"
	exit
end

require 'json'
require 'base64'

require_relative './player_log_reader'
require_relative './player_event_listener'

file = File.read(ARGV.first)
match = JSON.parse(file, symbolize_names: true)

def format_time(time)
	min = time / 3600
	sec = (time % 3600) / 60
	msec = (time % 60) / 0.6

	"#{min}:#{sec.to_s.rjust(2, '0')}.#{msec.round.to_s.rjust(2, '0')}"
end

# Hashes with default values for missing keys
events = Hash.new { |h, k| h[k] = [] }
pops = Hash.new { |h, k| h[k] = {} }

match[:players].each do |player|
	player_log = Base64.decode64(player[:events])
	reader = PlayerLogReader.new(player_log, player[:team], match[:duration])
	
	listener = PlayerEventListener.new(events, pops, player)

	reader.subscribe(listener)

	# This syntax is also supported thanks to the Wisper gem:
	# reader.on(:join) { |time, team| ... }

	reader.parse!
end

events.sort.to_h.each do |time, messages|
	messages.each do |message|
		puts "#{format_time(time)} #{message}"
	end
end