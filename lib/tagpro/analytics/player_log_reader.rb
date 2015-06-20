require 'wisper'

require 'tagpro/analytics/log_reader'

module TagPro
	module Analytics
		class PlayerLogReader < LogReader
			include Wisper::Publisher

			#TEAM_NONE = 0
			TEAM_RED = 1
			TEAM_BLUE = 2

			#FLAG_NONE = 0
			FLAG_OPPONENT = 1
			FLAG_OPPONENT_POTATO = 2
			FLAG_NEUTRAL = 3
			FLAG_NEUTRAL_POTATO = 4
			FLAG_TEMPORARY = 5

			POWER_NONE = 0
			POWER_JUKE_JUICE = 1
			POWER_ROLLING_BOMB = 2
			POWER_TAGPRO = 4
			POWER_TOP_SPEED = 8

			attr_reader :team,
				:block,
				:button,
				:captures,
				:duration,
				:flag,
				:is_drop_pop,
				:is_grab,
				:is_keep,
				:new_flag,
				:new_team,
				:powers,
				:powers_down,
				:powers_up,
				:powerups,
				:prevent,
				:returns,
				:tags,
				:time

			def initialize(data, team, duration)
				super(data)

				@team = team == 0 ? nil : team
				@duration = duration

				@time = 0
				@flag = nil
				@powers = POWER_NONE
				@prevent = false
				@button = false
				@block = false
			end

			def parse!
				while !end?
					init_new_team
					@is_drop_pop = read_bool
					@returns = read_tally
					@tags = read_tally
					@is_grab = !flag && read_bool

					@captures = read_tally
					
					@is_keep = !is_drop_pop && new_team && (new_team == team || !team) &&
						(captures == 0 || (!flag && !is_grab) || read_bool)
					
					init_new_flag

					init_powerups

					toggle_prevent = read_bool
					toggle_button = read_bool
					toggle_block = read_bool
					
					@time += 1 + read_footer

					if (!team && new_team)
						@team = new_team
						publish(:join, time, team)
					end

					returns.times do 
						publish(:return, time, flag, powers, team)
					end

					tags.times do
						publish(:tag, time, flag, powers, team)
					end

					if is_grab
						@flag = new_flag
						publish(:grab, time, flag, powers, team)
					end

					if captures > 0
						if is_keep
							captures.times do
								publish(:flagless_capture, time, flag, powers, team)
							end
						else
							captures.times do
								publish(:capture, time, flag, powers, team)
							end
							@flag = nil
						end
					end

					i = 1
					while i < 16
						if powers_down & i != POWER_NONE
							@powers ^= i
							publish(:powerdown, time, flag, i, powers, team)
						elsif powers_up & i != POWER_NONE
							@powers |= i
							publish(:powerup, time, flag, i, powers, team)
						end

						i = i << 1
					end

					powerups.times do
						publish(:duplicate_powerup, time, flag, powers, team)
					end

					if toggle_prevent
						publish(prevent ? :stop_prevent : :start_prevent, time, flag, powers, team)
						@prevent = !prevent
					end

					if toggle_button
						publish(button ? :stop_button : :start_button, time, flag, powers, team)
						@button = !button
					end

					if toggle_block
						publish(block ? :stop_block : :start_block, time, flag, powers, team)
						@block = !block
					end

					if is_drop_pop
						if flag
							publish(:drop, time, flag, powers, team)
							@flag = nil
						else
							publish(:pop, time, powers, team)
						end
					end

					if new_team != team
						if new_team
							publish(:switch, time, flag, powers, new_team)
						else
							publish(:quit, time, flag, powers, team)
							@powers = POWER_NONE
						end

						@flag = nil
						@team = @new_team
					end
				end

				publish(:end, duration, flag, powers, team)
			end

			def init_new_team
				@new_team = if read_bool
					if team
						if read_bool
							nil # quit
						else
							3 - team # switch
						end
					else
						1 + (read_bool ? 1 : 0) # join
					end
				else
					team # stay
				end
			end

			def init_new_flag
				@new_flag = if is_grab
					if is_keep
						1 + read_fixed(2)
					else
						FLAG_TEMPORARY
					end
				else
					flag
				end
			end

			def init_powerups
				@powerups = read_tally

				@powers_down = POWER_NONE
				@powers_up = POWER_NONE

				i = 1
				while i < 16
					if (powers & i) != POWER_NONE

						if read_bool
							@powers_down |= i
						end
					elsif powerups > 0 && read_bool
						@powers_up |= i
						@powerups -= 1
					end

					i = i << 1
				end


			end
		end
	end
end
