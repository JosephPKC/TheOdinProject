
class Pos
  attr_accessor :row, :col

  def initialize(r, c)
    raise 'row and col cannot be negative.' if r < 0 || c < 0
    @row = r
    @col = c
  end

  def to_s
    "(#{@row}, #{@col})"
  end

  def ==(o)
    o.class == self.class && o.row == @row && o.col == @col
  end
end