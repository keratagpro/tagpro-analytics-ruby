require 'tagpro/analytics/map_tiles'

module TagPro
	module Analytics
		class MapEventListener
			attr_reader :map_height

			def height(y)
				puts
				@map_height = y + 1
			end

			def tile(x, y, tile)
				case tile
				when MapTiles::WALL_SQUARE
					print '■'
				when MapTiles::WALL_DIAGONAL_BOTTOM_LEFT
					print '◣'
				when MapTiles::WALL_DIAGONAL_TOP_LEFT
					print '◤'
				when MapTiles::WALL_DIAGONAL_TOP_LEFT
					print '◥'
				when MapTiles::WALL_DIAGONAL_BOTTOM_RIGHT
					print '◢'
				when MapTiles::FLAG_RED, MapTiles::FLAG_BLUE, MapTiles::FLAG_NEUTRAL
					print '⚑'
				when MapTiles::POWERUP
					print '◎'
				when MapTiles::SPIKE
					print '☼'
				when MapTiles::BUTTON
					print '•'
				when MapTiles::GATE_OPEN, MapTiles::GATE_CLOSED, MapTiles::GATE_RED, MapTiles::GATE_BLUE
					print '▦'
				when MapTiles::BOMB
					print '☢'
				else
					print ' '
				end
			end
		end
	end
end
