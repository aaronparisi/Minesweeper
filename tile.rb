require 'colorize'
require 'byebug'

class Tile



    attr_accessor :revealed, :flagged, :neighbors
    attr_reader :armed

    def initialize(armed = false)
        @armed = armed
        @revealed = false
        @flagged = false
        @neighbors = 0
    end

    def reveal()
        @revealed = true
    end

    def hide()
        @revealed = false
    end

    def flag()
        @flagged = true
    end

    def unflag()
        @flagged = false
    end

    def show_yourself()
        #debugger
        if revealed
            armed ? "*".red : (neighbors == 0 ? "_".colorize(:blue) : neighbors.to_s.colorize(:green))
        else
            flagged ? "F".colorize(:white) : " "
        end
    end

    def is_armed?()
        armed
    end

    def lay_mine()
        @armed = true
    end

    def set_neighbors(num)
        @neighbors = num
    end

    def add_neighbor()
        @neighbors += 1
    end

    def take_action(action)
        #debugger
        case action
        when "f"
            #puts "going to flag #{self}"
            flag
        when "r"
            puts "going to reveal #{self}"
            reveal
        when "u"
            unflag
        end
    end
end