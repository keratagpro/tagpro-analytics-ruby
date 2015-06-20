require 'wisper'

require 'tagpro/analytics/log_reader'

module TagPro
	module Analytics
		class SplatLogReader < LogReader
			include Wisper::Publisher

			attr_reader :width, :height

			def initialize(data, width, height)
				super(data)

				@width = width
				@height = height
			end

			def bits(size)
				size *= 40
				grid = size - 1
				result = 32

				if grid & 0xFFFF0000 == 0
					result -= 16
					grid <<= 16
				end

				if grid & 0xFF000000 == 0
					result -= 8
					grid <<= 8
				end

				if grid & 0xF0000000 == 0
					result -= 4
					grid <<= 4
				end

				if grid & 0xC0000000 == 0
					result -= 2
					grid <<= 2
				end

				if grid & 0x80000000 == 0
					result -= 1
				end

				[result, ((1 << result) - size >> 1) + 20]
			end

			def parse!
				x = bits(width)
				y = bits(height)

				time = 0
				while !end?
					i = read_tally

					if i != 0
						splats = []

						i.times do
							splats << [read_fixed(x[0]) - x[1], read_fixed(y[0]) - y[1]]
						end

						publish(:splats, splats, time)
					end

					time += 1
				end
			end
		end
	end
end