require_relative 'board'

class Minesweeper

    attr_reader :board

    def initialize(row_size = 5, num_mines = 3)
        @board = Board.new(row_size, num_mines)
    end

    def blow_up()
        board.lost_game()
    end

    def celebrate
        board.render
        puts "you won!"
    end

    def take_turn()
        puts "enter a location you'd like to guess"
        pos = gets.chomp()
        puts "enter action you'd like to take"
        action = gets.chomp()

        take_step(pos, action)

        pos
    end

    def take_step(pos, action)
        tile = board[pos]
        tile.take_action(action)
    end

    def play_game()
        board.lay_mines()
        while true
            last_move = take_turn
            blow_up if board.tripped_mine?(last_move)
            celebrate if board.field_cleared?
        end
    end
end

m1 = Minesweeper.new()
m1.play_game