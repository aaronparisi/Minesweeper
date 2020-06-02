class Tile



    attr_accessor :revealed, :flagged, :neighbors
    attr_reader :bomb

    def initialize(bomb = false)
        @bomb = bomb
        @revealed = false
        @flagged = false
        @neighbors = 0
    end

    def reveal_tile()
        @revealed = true
    end

    def hide_tile()
        @revealed = false
    end

    def flag_tile()
        @flagged = true
    end

    def unflag_tile()
        @flagged = false
    end

    def show_yourself()
        # 1. if ! revealed, return " "
        if ! revealed
            flagged ? "F" : " "
        else
            neighbors == 0 ? "_" : neighbors.to_s
        end
    end

    def is_a_bomb?()
        bomb
    end

    def plant_bomb()
        @bomb = true
    end
end