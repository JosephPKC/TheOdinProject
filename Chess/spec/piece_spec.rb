
require 'pos'
require 'piece'


RSpec.describe 'Piece' do
  let(:piece) do
    Piece.new(Pos.new(1,1), true, '♙', :pawn)
  end

  context 'Given parameters (1,1), true, :pawn, ♙ ' \
          'for pos, is_white, type, and face respectively' do
    it 'is a Piece with all of those parameters' do
      expect(piece).to be_instance_of Piece
      expect(piece.pos).to be == Pos.new(1,1)
      expect(piece.team).to eql :white
      expect(piece.type).to eql :pawn
      expect(piece.face).to eql '♙'
      expect(piece.move_set).to eql ({})
    end
  end

  describe '.to_s' do
    context 'Given a face of ♙' do
      it 'returns ♙' do
        expect(piece.to_s).to eql '♙'
      end
    end
  end
end

