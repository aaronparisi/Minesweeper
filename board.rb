require_relative 'tile'

class Board

    attr_accessor :grid
    attr_reader :row_size, :num_mines

    def initialize(row_size = 3, num_mines = 3)
        @num_mines = num_mines
        @row_size = row_size
        @grid = Array.new(3) {Array.new(3) {Tile.new()}}

        lay_mines()
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
        [rand(row_size), rand(row_size)]
    end

    def lay_mines()
        planted = 0
        until planted == num_mines do
            mine_loc = nil
            mine_loc = get_random_loc until mine_loc && ! self[mine_loc].is_armed?

            self[mine_loc].lay_mine

            all_neighbors = get_all_neighbors(mine_loc)
            all_neighbors.each{|neigh| neigh.add_neighbor()}
            
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

    def reveal_all()
        grid.each do |row|
            row.each {|tile| tile.reveal}
        end
    end

    def tripped_mine?(pos)
        self[pos].armed?
    end

    def field_cleared?()
        grid.all? do |row|
            row.all? do |tile|
                ! tile.revealed if tile.is_armed?()
                tile.revealed if ! tile.is_armed?()
            end
        end
    end

    def lost_game()
        reveal_all
        render
        puts "Ka-boom!"
    end

    def won_game()
        puts "you won!"
    end

    def reveal_tile(pos)
        grid[pos].reveal()
    end

    def flag_tile(pos)
        grid[pos].flag()
    end

    def on_board?(pos)
        x, y = pos
        x.between?(0, row_size-1) && y.between?(0, row_size-1)
    end

    def get_all_neighbors(pos)
        x, y = pos
        ret = []
        (-1..1).each do |xval|
            (-1..1).each do |yval|
                new_pos = [x+xval, y+yval]
                ret << self[new_pos] if on_board?(new_pos)
            end
        end
        ret
    end

    # def num_armed_neighbors(pos)
    #     this_tile = self[pos]
    #     neighbors = get_all_neighbors(pos)
    #     total = neighbors.count {|neigh| neigh.armed}
    #     this_tile.set_neighbors(total)
    # end

    # def reveal_bombs()
    #     grid.each do |row|
    #         puts row.map {|tile| tile.show_yourself()}.join(" ")
    #         puts
    #     end
    # end
end