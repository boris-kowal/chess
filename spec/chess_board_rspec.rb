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
end
    