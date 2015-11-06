module TagPro
	module Analytics
		class LogReader
			def initialize(data)
				@data = data
				@pos = 0
			end

			protected

			def end?
				(@pos >> 3) >= @data.length
			end

			def read_bool
				result = end? ? 0 : @data[@pos >> 3].ord >> 7 - (@pos & 7) & 1;
				@pos += 1
				return result != 0
			end

			def read_fixed(bits)
				result = 0

				bits.times do
					result = (result << 1) | (read_bool ? 1 : 0)
				end

				return result
			end

			def read_tally
				result = 0

				while read_bool
					result += 1
				end

				return result
			end

			def read_footer
				size = read_fixed(2) << 3
				free = (8 - (@pos & 7)) & 7
				size |= free
				minimum = 0

				while free < size
					minimum += 1 << free
					free += 8
				end

				return read_fixed(size) + minimum
			end
		end
	end
end
