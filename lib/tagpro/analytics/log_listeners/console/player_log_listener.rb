module TagPro
	module Analytics
		module LogListeners
			module Console
				class PlayerLogListener
					attr_accessor :player
					attr_reader :events, :pops

					def initialize(events, pops, player)
						@player = player
						@events = events
						@pops = pops

						if player[:team] != 0
							@events[0] << "#{player[:name]} starts in team #{player[:team]}"
						end
					end

					def join(time, team)
						events[time] << "#{player[:name]} joins team #{team}"
					end

					def quit(time, flag, powers, team)
						events[time] << "#{player[:name]} quits team #{team}"
					end

					def switch(time, flag, powers, team)
						events[time] << "#{player[:name]} switches to team #{team}"
					end

					def grab(time, flag, powers, team)
						events[time] << "#{player[:name]} grabs flag #{flag}"
					end

					def capture(time, flag, powers, team)
						events[time] << "#{player[:name]} captures flag #{flag}"
					end

					def flagless_capture(time, flag, powers, team)
						events[time] << "#{player[:name]} captures marsball"
					end

					def powerup(time, flag, powerup, powers, team)
						events[time] << "#{player[:name]} powers up #{powerup}"
					end

					def duplicate_powerup(time, flag, powers, team)
						events[time] << "#{player[:name]} extends power"
					end

					def powerdown(time, flag, powerdown, powers, team)
						events[time] << "#{player[:name]} powers down #{powerdown}"
					end

					def return(time, flag, powers, team)
						events[time] << "#{player[:name]} returns"
					end

					def tag(time, flag, powers, team)
						events[time] << "#{player[:name]} tags"
					end

					def drop(time, flag, powers, team)
						events[time] << "#{player[:name]} drops flag #{flag}"
						pops[team][time] = true
					end

					def pop(time, powers, team)
						events[time] << "#{player[:name]} pops"
						pops[team][time] = true
					end

					def start_prevent(time, flag, powers, team)
						events[time] << "#{player[:name]} starts preventing"
					end

					def stop_prevent(time, flag, powers, team)
						events[time] << "#{player[:name]} stops preventing"
					end

					def start_button(time, flag, powers, team)
						events[time] << "#{player[:name]} starts buttoning"
					end

					def stop_button(time, flag, powers, team)
						events[time] << "#{player[:name]} stops buttoning"
					end

					def start_block(time, flag, powers, team)
						events[time] << "#{player[:name]} starts blocking"
					end

					def stop_block(time, flag, powers, team)
						events[time] << "#{player[:name]} stops blocking"
					end

					def end(time, flag, powers, team)
						if player[:team]
							events[time] << "#{player[:name]} ends in team #{team}"
						end
					end
				end
			end
		end
	end
end
