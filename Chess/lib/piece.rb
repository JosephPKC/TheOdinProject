
class Piece
  require 'pos'

  attr_accessor :pos, :team, :face, :type, :move_set

  def initialize(pos, is_white = true, face = nil, type = nil, move_set = {})
    raise 'Expected pos to be of type Pos.' unless pos.is_a? Pos
    @pos = pos
    @team = is_white ? :white : :black
    @face = face
    @type = type
    @move_set = move_set
  end

  def to_s
    @face
  end

  private

  def moves(_board)
    []
  end
end