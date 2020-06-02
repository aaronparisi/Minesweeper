require_relative 'board'

class Minesweeper
    def initialize(row_size = 3, num_mines = 3)
        @board = Board.new(row_size, num_mines)
        
    end
end