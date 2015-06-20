require 'wisper'

require 'tagpro/analytics/log_reader'

module TagPro
	module Analytics
		class MapLogReader < LogReader
			include Wisper::Publisher

			attr_reader :width

			def initialize(data, width)
				super(data)

				@width = width
			end

			def parse!
				x = 0
				y = 0

				while !end? || x > 0
					if (tile = read_fixed(6)) != 0
						if tile < 6
							tile += 9
						elsif tile < 13
							tile = (tile - 4) * 10
						elsif tile < 17
							tile += 77
						elsif tile < 20
							tile = (tile - 7) * 10
						elsif tile < 22
							tile += 110
						else
							tile = (tile - 8) * 10
						end
					end

					(1 + read_footer).times do
						if x == 0
							publish(:height, y)
						end

						publish(:tile, x, y, tile)

						x += 1
						if x == width
							x = 0
							y += 1
						end
					end
				end
			end
		end
	end
end