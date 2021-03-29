require_relative 'chess_board.rb'
require 'pry'

class Game
  def initialize
    @new_game = Board.new
    @colors = ['white', 'black']
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
    until check?
      one_round(player)
      switch_player
      @new_game.find_available_moves
    end
  end

  def check?
    check_color?('white') || check_color?('black')
  end

  def check_color?(color)
    @new_game.board.each_value do |element|
      next if element.edges.nil? || element.color == color
      element.edges.each do |position|
        piece = @new_game.board[position]
        if piece.class == King && piece.color == color
          return true
        else
          next
        end
      end
    end
    false
  end


  def no_move?(piece)
    piece.edges.empty?
  end

  def one_round(player)
    @new_game.display
    from = get_input_from(player)
    while no_move?(@new_game.board[from])
      print "there is no valid move for this piece. "
      from = get_input_from(player)
    end
    to = get_input_to
    while @new_game.move_pieces(from, to) == 'Illegal move'
      puts 'Illegal move'
      to = get_input_to
    end
    @new_game.display
  end

  def get_input_to
    puts 'Enter the position where you want to move'
    input = gets.chomp
    coordinates = @new_game.find_coordinates(input)
    while coordinates == nil
      puts 'Enter a valid position'
      input = gets.chomp
      coordinates = @new_game.find_coordinates(input)
    end
    coordinates
  end

  def get_input_from(player)
    puts 'Enter the position of the piece you want to move'
    input = gets.chomp
    coordinates = @new_game.find_coordinates(input)
    while coordinates == nil || @new_game.board[coordinates].color != player.color || @new_game.board[coordinates].class == EmptyCell
      puts 'Enter a valid position'
      input = gets.chomp
      coordinates = @new_game.find_coordinates(input)
    end
    coordinates
  end

end

game = Game.new