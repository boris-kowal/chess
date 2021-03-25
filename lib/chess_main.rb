require_relative 'chess_board.rb'
require 'pry'

class Game
  def initialize
    @new_game = Board.new
    play
  end

  def play
    while true
      one_round
    end
  end

  def one_round
    @new_game.display
    puts 'Enter the position of the piece you want to move'
    from = get_input
    puts 'Enter the position where you want to move'
    to = get_input
    find_available_moves(from)
    @new_game.move_pieces(from, to)
    @new_game.display
  end

  def find_available_moves(from)
    while @new_game.board[from].class == EmptyCell
      puts "Please enter a valid choice"
      from = get_input
    end
    if [King, Pawn, Knight].include?(@new_game.board[from].class)
      return
    else
      @new_game.find_edges(@new_game.board[from])
    end
  end

  def get_input
    input = gets.chomp
    index = @new_game.find_index(input)
    while index == nil
      puts 'Enter a valid position'
      input = gets.chomp
      index = @new_game.find_index(input)
    end
    index
  end

end

game = Game.new