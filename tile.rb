class Tile

    attr_accessor :revealed
    attr_reader :bomb

    def initialize(bomb = false)
        @bomb = bomb
        @revealed = false
    end

    def reveal_tile()
        @revealed = true
    end

    def hide_tile()
        @revealed = false
    end
end