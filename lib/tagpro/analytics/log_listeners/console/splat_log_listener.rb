require 'tagpro/analytics/util'

module TagPro
	module Analytics
		module LogListeners
			module Console
				class SplatLogListener
					attr_reader :pops
					attr_reader :index

					def initialize(pops, index)
						@pops = pops
						@index = index
					end

					def splats(splats, time)
						splats.each do |splat|
							puts "#{Util.format_time(pops[index + 1][time])} (#{splat[0]},#{splat[1]})"
						end
					end
				end
			end
		end
	end
end
