require 'yaml'

require_relative 'board'

class Minesweeper

    attr_reader :board

    def initialize(row_size = 10, num_mines = 10)
        @board = File.exists?("a_board.yml") ? YAML.load(File.read("a_board.yml")) : Board.new(row_size, num_mines)
        #@board = Board.new(row_size, num_mines)
    end

    def blow_up()
        board.lost_game()
    end

    def celebrate
        board.render
        puts "you won!"
    end

    def take_turn()
        board.render
        puts "enter a location you'd like to guess in the form 'x,y'"
        pos = gets.chomp().split(",").map {|n| Integer(n)}
        puts "enter action you'd like to take"
        action = gets.chomp()
        #debugger
        return nil if action == "quit"
        take_step(pos, action)

        [pos, action]
    end

    def take_step(pos, action)
        tile = board[pos]
        tile.take_action(action)
    end

    def fan_out(pos)
        all_neighbors = board.get_all_neighbors(pos).filter {|tile| ! tile.revealed}
        unless all_neighbors.any? {|neigh| neigh.armed}
            all_neighbors.each do |neigh|
                neigh.reveal
                #debugger
                fan_out(board.get_tile_pos(neigh)) if ! neigh.armed
            end
        end
    end

    def leave_game()
        puts "Would you like to save the game? y/n"
        save = gets.chomp()
        if save == "y"
            File.open("a_board.yml", "w") {|file| file.write(board.to_yaml)}
        else
            # delete any saved board files so they don't get loaded next time
            File.delete("a_board.yml") if File.exist?("a_board.yml")
        end
    end

    def play_game()
        board.lay_mines() if ! File.exist?("a_board.yml")
        while true
            last_move = take_turn
            #debugger
            if last_move == nil
                leave_game()
                break
            elsif "fu".include?(last_move[1])
                next
            elsif board.tripped_mine?(last_move[0])
                blow_up
                break
            elsif board.field_cleared?
                celebrate
                break
            else
                fan_out(last_move[0])
            end
        end
    end
end

m1 = Minesweeper.new()
m1.play_game