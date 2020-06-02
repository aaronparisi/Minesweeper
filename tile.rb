class Tile



    attr_accessor :revealed, :flagged
    attr_reader :bomb

    def initialize(bomb = false)
        @bomb = bomb
        @revealed = false
        @flagged = false
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

    def get_tile_char()
        # not sure if this is gonna happen in here or in Board class??
    end

    def is_a_bomb?()
        bomb
    end

    def plant_bomb()
        @bomb = true
    end
end