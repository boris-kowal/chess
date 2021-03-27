require_relative '../lib/chess_main'
require 'pry'

describe Game do
  describe '#check?' do
    suject(:check_game) {described_class.new}
    

    context 'when in check' do
      before do
        check_game.new_game.move_pieces(37, 39)
        check_game.new_game.move_pieces(51, 49)
        allow(check_game).to receive(find_available_moves)
      end
      it 'return true' do
        check_game.new_game.move_pieces(27, 67)
        expect {check_game.check?('black')}.to eq(true)
      end
    end
    context 'when not in check' do
      before do
        check_game.new_game.move_pieces(37, 39)
        check_game.new_game.move_pieces(51, 49)
      end
      it 'return false' do
        expect {check_game.check?('black')}.to eq(false)
      end
    end
  end
end
