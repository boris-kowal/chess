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
        move_game.move_pieces(28, 30)
        move_game.move_pieces(37, 39)
      end
      it 'does not change position' do
        board = move_game.instance_variable_get(:@board)
        expect { move_game.move_pieces(18,38) }.not_to (change { board[38] })
      end
    end
    context 'when moving to illegal position' do
      it 'does not change position' do
        board = move_game.instance_variable_get(:@board)
        expect { move_game.move_pieces(27,29) }.not_to (change { board[27] })
      end
    end
    context 'when moving pawn to free position' do
      it 'move the pieces' do
        board = move_game.instance_variable_get(:@board)
        expect { move_game.move_pieces(28,30) }.to (change { board[30] }).from(EmptyCell).to(Pawn)
      end
    end
    context 'when moving pawn to illegal position' do
      it 'does not move the pieces' do
        board = move_game.instance_variable_get(:@board)
        expect { move_game.move_pieces(28,38) }.not_to (change { board[38] })
      end
    end
    context 'when moving knight to free position' do
      it 'move the pieces' do
        board = move_game.instance_variable_get(:@board)
        expect { move_game.move_pieces(9,20) }.to (change { board[20] }).from(EmptyCell).to(Knight)
      end
    end
    context 'when moving knight to illegal position' do
      it 'move the pieces' do
        board = move_game.instance_variable_get(:@board)
        expect { move_game.move_pieces(9,28) }.not_to (change { board[28] })
      end
    end
    context 'when moving Bishop to free position' do
      before do
        move_game.move_pieces(28, 30)
        move_game.find_edges(move_game.board[18])
      end
      it 'move the pieces' do
        board = move_game.instance_variable_get(:@board)
        expect { move_game.move_pieces(18,48) }.to (change { board[48] }).from(EmptyCell).to(Bishop)
      end
    end
    context 'when moving Bishop to illegal position' do
      before do
        move_game.find_edges(move_game.board[18])
      end
      it 'move the pieces' do
        board = move_game.instance_variable_get(:@board)
        expect { move_game.move_pieces(18,2) }.not_to (change { board[2] })
      end
    end
    context 'when moving Rook to free position' do
      before do
        move_game.move_pieces(64, 66)
        move_game.find_edges(move_game.board[63])
      end
      it 'move the pieces' do
        board = move_game.instance_variable_get(:@board)
        expect { move_game.move_pieces(63, 65) }.to (change { board[65] }).from(EmptyCell).to(Rook)
      end
    end
    context 'when moving Rook to illegal position' do
      before do
        move_game.find_edges(move_game.board[63])
      end
      it 'move the pieces' do
        board = move_game.instance_variable_get(:@board)
        expect { move_game.move_pieces(63, 66) }.not_to (change { board[66] })
      end
    end
    context 'when moving queen to free position' do
      before do
        move_game.move_pieces(37, 39)
        move_game.find_edges(move_game.board[27])
      end
      it 'move the pieces' do
        board = move_game.instance_variable_get(:@board)
        expect { move_game.move_pieces(27, 67) }.to (change { board[67] }).from(EmptyCell).to(Queen)
      end
    end
    context 'when moving queen to illegal position' do
      before do
        move_game.find_edges(move_game.board[27])
      end
      it 'move the pieces' do
        board = move_game.instance_variable_get(:@board)
        expect { move_game.move_pieces(27,31) }.not_to (change { board[31] })
      end
    end
    context 'when moving king to free position' do
      before do
        move_game.move_pieces(28,29)
      end
      it 'move the pieces' do
        board = move_game.instance_variable_get(:@board)
        expect { move_game.move_pieces(36,28) }.to (change { board[28] }).from(EmptyCell).to(King)
      end
    end
    context 'when moving king to illegal position' do
      it 'move the pieces' do
        board = move_game.instance_variable_get(:@board)
        expect { move_game.move_pieces(36,38) }.not_to (change { board[38] })
      end
    end
  end
end
    