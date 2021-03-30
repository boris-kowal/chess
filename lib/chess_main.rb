require_relative 'chess_board'
require 'pry'

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
    while check? == false
      one_round(player)
      switch_player
      @new_game.find_available_moves
    end
    if checkmate?(@king, @attacker) == true
      puts 'Checkmate!'
    else
      puts 'Check!'
      one_round(player)
      switch_player
      play
    end
  end

  def check?
    check_color?('white') || check_color?('black')
  end

  def checkmate?(king, attacker)
    @new_game.find_available_moves
    attacked = @new_game.attacked_squares(attacker.color)
    king.edges.each do |position|
      if !attacked.has_value?(position)
        @new_game.move_pieces(king.position, position)
        @new_game.find_available_moves
        unless check?
          @new_game.reverse_move
          @new_game.find_available_moves
          return false
        end
        @new_game.reverse_move
        @new_game.find_available_moves
      else
        next
      end
    end
    attacked = @new_game.attacked_squares(king.color)
    attacked.each do |key, value|
      if value.include?(attacker.position)
        @new_game.move_pieces(key.position, attacker.position)
        @new_game.find_available_moves
        unless check?
          @new_game.reverse_move
          @new_game.find_available_moves
          return false
        end
      else
        next
      end
      @new_game.reverse_move
      @new_game.find_available_moves
    end
    attacked.each do |key, array|
      array.each do |position|
        @new_game.move_pieces(key.position, position)
        @new_game.find_moves(attacker.color)
        if check?
          @new_game.reverse_move
          @new_game.find_available_moves
          next
        else
          @new_game.reverse_move
          return false
        end
      end
    end
    true
  end

  def check_color?(color)
    @new_game.board.each_value do |element|
      next if element.edges.nil? || element.color == color

      element.edges.each do |position|
        piece = @new_game.board[position]
        if piece.instance_of?(King) && piece.color == color
          @king = piece
          @attacker = element
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
      print 'there is no valid move for this piece. '
      from = get_input_from(player)
    end
    to = get_input_to
    while @new_game.move_pieces(from, to) == 'Illegal move'
      puts 'Illegal move'
      to = get_input_to
    end
    @new_game.find_available_moves
    if check_color?(player.color)
      puts 'Illegal move, you would be in check!'
      @new_game.reverse_move
      play
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
    coordinates
  end
end

game = Game.new
