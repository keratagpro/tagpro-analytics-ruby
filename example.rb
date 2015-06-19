if ARGV.length < 1
	puts "Usage: #{File.basename($0)} <filename>"
	exit
end

require 'json'
require 'base64'

require_relative './map_log_reader'
require_relative './map_event_listener'
require_relative './player_log_reader'
require_relative './player_event_listener'
require_relative './splat_log_reader'
require_relative './splat_event_listener'
require_relative './util'

file = File.read(ARGV.first)
match = JSON.parse(file, symbolize_names: true)

map_log = Base64.decode64(match[:map][:tiles])
map_reader = MapLogReader.new(map_log, match[:map][:width])

map_listener = MapEventListener.new
map_reader.subscribe(map_listener)

puts "MAP"
map_reader.parse!

# Hashes with default values for missing keys
events = Hash.new { |h, k| h[k] = [] }
pops = Hash.new { |h, k| h[k] = {} }

puts
puts "TIMELINE"
match[:players].each do |player|
	player_log = Base64.decode64(player[:events])
	player_reader = PlayerLogReader.new(player_log, player[:team], match[:duration])
	player_listener = PlayerEventListener.new(events, pops, player)
	player_reader.subscribe(player_listener)
	player_reader.parse!
end

events.sort.to_h.each do |time, messages|
	messages.each do |message|
		puts "#{Util.format_time(time)} #{message}"
	end
end

match[:teams].each_with_index do |team, index|
	puts
	puts "TEAM #{index + 1} SPLATS"
	pops_sorted = pops[index + 1].sort.to_h
	pops[index + 1] = pops_sorted.keys

	splat_log = Base64.decode64(team[:splats])
	splat_reader = SplatLogReader.new(splat_log, match[:map][:width], map_listener.map_height || 1)

	splat_listener = SplatEventListener.new(pops, index)
	splat_reader.subscribe(splat_listener)
	splat_reader.parse!
end