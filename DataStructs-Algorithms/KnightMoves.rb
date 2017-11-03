class Loc
  attr_reader :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def equals?(other)
    @x == other.x && @y == other.y
  end
end

class ChessBoard
  attr_reader :start, :max

  def initialize(start_x, start_y)
    @max = Loc.new(8, 8)
    @start = Loc.new(start_x, start_y)
  end
end



def knight_moves(start = [0,0], dest = [0,0])
  hist = []
  knight_moves_rec(start, dest, hist)
end

def knight_moves_rec(start, dest, hist)
  # Create the BT dynamically breadth-wise. Stop when you find an answer, and all other subtree lengths are longer.
end