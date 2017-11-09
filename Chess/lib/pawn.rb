
class Pawn < Piece
  require 'piece'
  require 'board'

  attr_accessor :moved, :passing

  def initialize(pos, is_white = true)
    super(pos, is_white,
        is_white ? '♙' : '♟',
        :pawn,
        create_move_set(is_white)
    )
    @moved = false
    @passing = false
  end

  def moves(board)
    # Perform all move_sets (abiding by their key rules)
    move_list = {}
    @move_set.each_pair do |type, move|
      move.each do |m|
        dest = Pos.new(pos.row + m[0], pos.col + m[1])

        move_list[type] << dest if move_list.include?(type)
        move_list[type] = [dest] unless move_list.include?(type)
      end
    end
    move_list
  end

  private

  def create_move_set(is_white)
    {
      move_only: is_white ? [[-1, 0]] : [[1, 0]],
      double_move: is_white ? [[-2, 0]] : [[2, 0]],
      attack_only: is_white ? [[-1, 1], [-1, -1]] : [[1, 1], [1, -1]],
      en_passant: is_white ? [[-1, 1], [-1, -1]] : [[1, 1], [1, -1]]
    }
  end


end