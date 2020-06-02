require_relative 'tile'

class Board

    attr_accessor :grid
    attr_reader :rowSize, :num_bombs

    def initialize(rowSize = 3, num_bombs = 3)
        @num_bombs = num_bombs
        @rowSize = rowSize
        @grid = Array.new(3) {Array.new(3) {Tile.new()}}

        plant_bombs()
    end

    def [](pos)
        x, y = pos
        grid[x][y]
    end

    # the value of the tile should never be changed after initialization
    # def []=(pos)
    #     tile = self[pos]
    #     tile.change_val
    # end

    def get_random_loc()
        [rand(rowSize), rand(rowSize)]
    end

    def plant_bombs()
        planted = 0
        until planted == num_bombs do
            bomb_loc = get_random_loc
            bomb_loc = get_random_loc until ! self[bomb_loc].is_a_bomb?

            self[bomb_loc].plant_bomb
            
            planted += 1
        end
    end

    def render()
        grid.each do |row|
            puts row.map {|tile| tile.show_yourself()}.join(" ")
            puts
        end
        nil
    end

    def reveal_tile(pos)
        grid[pos].reveal()
    end

    def flag_tile(pos)
        grid[pos].flag()
    end

    # def reveal_bombs()
    #     grid.each do |row|
    #         puts row.map {|tile| tile.show_yourself()}.join(" ")
    #         puts
    #     end
    # end
end