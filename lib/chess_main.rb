require_relative 'chess_board'
require 'pry'
require 'colorize'

class Game
  def initialize
    @new_game = Board.new
    @colors = %w[white black]
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
    @new_game.find_available_moves
    while @new_game.check? == false
      one_round(player)
      switch_player
      @new_game.find_available_moves
    end
    if @new_game.checkmate?(@new_game.king, @new_game.attacker) == true
      puts 'Checkmate!'
    else
      puts 'Check!'
      one_round(player)
      switch_player
      play
    end
  end

  def no_move?(piece)
    piece.edges.empty?
  end

  def one_round(player)
    @new_game.display
    from = get_input_from(player)
    while no_move?(@new_game.board[from])
      print 'there is no valid move for this piece. '
      from = get_input_from(player)
    end
    to = get_input_to
    while @new_game.move_pieces(from, to) == 'Illegal move'
      puts 'Illegal move'
      to = get_input_to
    end
    @new_game.find_available_moves
    if @new_game.check_color?(player.color)
      puts 'Illegal move, you would be in check!'
      @new_game.reverse_move
      play
    end
  end

  def show_available_moves(piece)
    @tempo = []
    piece.edges.each do |element|
      if @new_game.board[element].class == EmptyCell
        @tempo.push(@new_game.board[element])
        @new_game.board[element] = Dot.new(element)
      else
        @tempo.push(@new_game.board[element])
        @new_game.board[element].symbol = '|' + @new_game.board[element].symbol[1] + '|'
      end
    end
  end

  def hide_available_move
    @tempo.each do |element|
      if element.class == EmptyCell
        @new_game.board[element.position] = element
      else
        @new_game.board[element.position].symbol = ' ' + @new_game.board[element.position].symbol[1] + ' '
      end
    end
  end

  def get_input_to
    puts 'Enter the position where you want to move'
    input = gets.chomp
    coordinates = @new_game.find_coordinates(input)
    while coordinates.nil?
      puts 'Enter a valid position'
      input = gets.chomp
      coordinates = @new_game.find_coordinates(input)
    end
    hide_available_move
    coordinates
  end

  def get_input_from(player)
    puts 'Enter the position of the piece you want to move'
    input = gets.chomp
    coordinates = @new_game.find_coordinates(input)
    while coordinates.nil? || @new_game.board[coordinates].color != player.color || @new_game.board[coordinates].instance_of?(EmptyCell)
      puts 'Enter a valid position'
      input = gets.chomp
      coordinates = @new_game.find_coordinates(input)
    end
    show_available_moves(@new_game.board[coordinates])
    @new_game.display
    coordinates
  end
end

game = Game.new
