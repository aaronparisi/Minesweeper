class Tile



    attr_accessor :revealed, :flagged, :neighbors
    attr_reader :bomb

    def initialize(bomb = false)
        @bomb = bomb
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
        # 1. if ! revealed, return " "
        if ! revealed
            flagged ? "F" : "*"
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