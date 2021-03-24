require_relative '../lib/chess_board'

describe Board do
  describe '#find_index' do
    subject(:game_index) {described_class.new}
    context 'when translating a1 coordinates into index' do
      it 'return 0' do
        result = game_index.find_index('a1')
        expect(result).to eq(0)
      end
    end
    context 'when translating h8 coordinates into index' do
      it 'return 70' do
        result = game_index.find_index('h8')
        expect(result).to eq(70)
      end
    end
    context 'when translating coordinates that do not exist' do
      it 'return nil' do
        result = game_index.find_index('2f')
        expect(result).to eq(nil)
      end
    end
    context 'when translating coordinates outside the grid' do
      it 'return nil' do
        result = game_index.find_index('a9')
        expect(result).to eq(nil)
      end
    end
  end
  describe '#move_pieces' do
    subject(:move_game) { described_class.new}
    context 'When moving to an already occupied position' do
      before do
        move_game.move_pieces(28, 29)
        move_game.move_pieces(37, 38)
      end
      it 'does not change position' do
        board = move_game.instance_variable_get(:@board)
        expect { move_game.move_pieces(18,38) }.not_to (change { board[38] })
      end
    end
    context 'when moving to illegal position' do
      it 'return nil' do
      end
    end
    context 'when moving to free position' do
      it 'move the pieces' do
      end
    end
  end
end
    