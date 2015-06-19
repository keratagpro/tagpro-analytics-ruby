module Util
	def self.format_time(time)
		min = time / 3600
		sec = (time % 3600) / 60
		msec = (time % 60) / 0.6

		"#{min}:#{sec.to_s.rjust(2, '0')}.#{msec.round.to_s.rjust(2, '0')}"
	end
end