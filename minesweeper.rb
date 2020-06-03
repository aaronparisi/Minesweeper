require 'yaml'

require_relative 'board'

class Minesweeper

    attr_reader :board

    def initialize(row_size = 10, num_mines = 10)
        #@board = File.exists?("a_board.yml") ? YAML.load(File.read("a_board.yml")) : Board.new(row_size, num_mines)
        @board = Board.new(row_size, num_mines)
        # this should not get called if we load the game from a yml file??
        @elapsed_time
    end

    def blow_up()
        board.lost_game()
    end

    def celebrate
        board.render
        puts "you won!"
    end

    def valid_input(val, type)
        return true if val == "quit"
        case type
        when "action"
            return "rfu".include?(val)
        when "position"
            return val.is_a?(Array) &&
                val.length == 2 &&
                val.all? {|i| i.between?(0,board.row_size-1)}
        end
    end

    def parse_input(val, type)
        case type
        when "action"
            return val
        when "position"
            return val.split(",").map { |char| Integer(char) }
        end
    end

    def get_input(type)
        ret = nil
        until ret && valid_input(ret, type)
            case type
            when "action"
                stmt = "Please choose one of the following actions\n'r' => reveal | 'f' => flag | 'u' => unflag | 'quit => quit game"
            when "position"
                stmt = "Please enter the position in the form 'x,y'"
            end
            puts stmt
            ret = parse_input(gets.chomp, type)
            #debugger
        end
        ret
    end

    def take_turn()
        board.render
        action = get_input("action")
        return if action == "quit"
        pos = get_input("position")

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

    def clean_up()
        File.delete("saved_game.yml") if File.exist?("saved_game.yml")
    end

    def leave_game()
        puts "Would you like to save the game? y/n"
        save = gets.chomp()
        if save == "y"
            File.open("saved_game.yml", "w") {|file| file.write(self.to_yaml)}
        else
            # delete any saved board files so they don't get loaded next time
            clean_up
        end
    end

    def play_game()
        board.lay_mines() if ! File.exist?("saved_game.yml")
        starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
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
                clean_up
                break
            elsif board.field_cleared?
                celebrate
                clean_up
                break
            else
                fan_out(last_move[0])
            end
        end
    end
end

m1 = File.exist?("saved_game.yml") ? YAML.load(File.read("saved_game.yml")) : Minesweeper.new()

m1.play_game
# ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
# elapsed = ending - starting
# puts "elapsed: #{elapsed}" # => 9.183449000120163 seconds