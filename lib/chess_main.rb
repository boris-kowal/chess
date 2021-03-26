require_relative 'chess_board.rb'
require 'pry'

class Game
  def initialize
    @new_game = Board.new
    @players = [Player.new('Player 1', 'white'), Player.new('Player 2', 'black')]
    @current_player_index = 0
    play
  end

  def other_player_index
    1 - @current_player_index
  end

  def player
    @players[@current_player_index]
  end

  def switch_player
    @current_player_index = other_player_index
  end

  def play
    while true
      one_round(player)
      switch_player
    end
  end

  def no_move?(piece)
    piece.edges.empty?
  end

  def one_round(player)
    @new_game.display
    from, to = get_input(player)
    while @new_game.move_pieces(from, to) == 'Illegal move'
      puts 'Illegal move'
      to = get_input_to
    end
    @new_game.display
  end

  def find_available_moves(from)
    if [King, Knight].include?(@new_game.board[from].class)
      return
    elsif @new_game.board[from].class == Pawn
      find_edges_pawn(@new_game.board[from])
    else
      @new_game.find_edges(@new_game.board[from])
    end
  end

  def find_edges_pawn(piece)
    i = piece.color == 'white'? 1 : -1
    index = @new_game.find_index_from_array(piece.position)
    if piece.first_round == false || @new_game.board[index + 2 * i].class != EmptyCell
      piece.edges.delete(@new_game.board[index + 2 * i].position)
    end
    if @new_game.board[index + i].class != EmptyCell
      piece.edges.delete(@new_game.board[index + i].position)
      piece.edges.delete(@new_game.board[index + 2 * i].position)
    end
    if @new_game.board[index + 10 * i].color != @players[1 - @current_player_index].color
      piece.edges.delete(@new_game.board[index + 10 * i].position)
    end
    if @new_game.board[index - 8 * i].color != @players[1 - @current_player_index].color
      piece.edges.delete(@new_game.board[index - 8 * i].position)
    end
  end

  def get_input(player)
    from = get_input_from(player)
    find_available_moves(from)
     while no_move?(@new_game.board[from])
       puts "There is no valid moves for this piece, please select another one"
       from = get_input_from(player)
       find_available_moves(from)
     end
    return from, get_input_to
  end

  def get_input_to
    puts 'Enter the position where you want to move'
    input = gets.chomp
    index = @new_game.find_index(input)
    while index == nil
      puts 'Enter a valid position'
      input = gets.chomp
      index = @new_game.find_index(input)
    end
    index
  end

  def get_input_from(player)
    puts 'Enter the position of the piece you want to move'
    input = gets.chomp
    index = @new_game.find_index(input)
    while index == nil || @new_game.board[index].color != player.color || @new_game.board[index].class == EmptyCell
      puts 'Enter a valid position'
      input = gets.chomp
      index = @new_game.find_index(input)
    end
    index
  end

end

game = Game.new