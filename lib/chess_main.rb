require_relative 'chess_board'
require 'pry'
require 'colorize'

class Game
  def initialize
    @new_game = Board.new
    @colors = %w[white black]
    @players = [Player.new('Player 1', 'white'), Player.new('Player 2', 'black')]
    @current_player_index = 0
    choose
  end

  def choose
    puts 'Do you want to start a new game or a saved game?'
    puts '[1] New game against the computer'
    puts '[2] New game with 2 players'
    puts '[3] Saved game'
    input = gets.chomp
    while !input.match(/[1-3]/) || input.length != 1
      puts 'please enter a valid choice'.red
      input = gets.chomp
    end
    play_computer if input == '1'
    play_human if input == '2'
    load_game if input == '3'
  end

  def play_computer
    @new_game.find_available_moves
    while @new_game.check? == false
      computer_player
      switch_player
      @new_game.find_available_moves
    end
    if @new_game.checkmate?(@new_game.king, @new_game.attacker) == true
      puts 'Checkmate!'.red
      @new_game.display
    else
      puts 'Check!'.red
      computer_player
      switch_player
      play_computer
    end
  end

  def computer_player
    if player == @players[0]
      one_round_player
    else
      one_round_computer
    end
  end

  def one_round_computer
    @new_game.display
    puts 'Computer playing...'.green
    sleep(1)
    attacked = @new_game.attacked_squares('black')
    key_index = rand(attacked.keys.length)
    key = attacked.keys[key_index]
    value_index = rand(attacked[key].length)
    @new_game.move_pieces(key.position, attacked[key][value_index])
  end

  def load_game
    puts 'to be coded'
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

  def play_human
    @new_game.find_available_moves
    while @new_game.check? == false
      one_round_player
      switch_player
      @new_game.find_available_moves
    end
    if @new_game.checkmate?(@new_game.king, @new_game.attacker) == true
      puts 'Checkmate!'.red
      @new_game.display
    else
      puts 'Check!'.red
      one_round_player
      switch_player
      play_human
    end
  end

  def no_move?(piece)
    piece.edges.empty?
  end

  def one_round_player
    @new_game.display
    from = get_input_from
    while no_move?(@new_game.board[from])
      print 'there is no valid move for this piece. '.red
      from = get_input_from
    end
    to = get_input_to
    while @new_game.move_pieces(from, to) == 'Illegal move'
      puts 'Illegal move'.red
      to = get_input_to
    end
    @new_game.find_available_moves
    if @new_game.check_color?(player.color)
      puts 'Illegal move, you would be in check!'
      @new_game.reverse_move
      play_human
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
    puts "#{player.name}, enter the position where you want to move"
    input = gets.chomp
    coordinates = @new_game.find_coordinates(input)
    while coordinates.nil?
      puts 'Enter a valid position'.red
      input = gets.chomp
      coordinates = @new_game.find_coordinates(input)
    end
    hide_available_move
    coordinates
  end

  def get_input_from
    puts "#{player.name}, enter the position of the piece you want to move"
    input = gets.chomp
    coordinates = @new_game.find_coordinates(input)
    while coordinates.nil? || @new_game.board[coordinates].color != player.color || @new_game.board[coordinates].instance_of?(EmptyCell)
      puts 'Enter a valid position'.red
      input = gets.chomp
      coordinates = @new_game.find_coordinates(input)
    end
    show_available_moves(@new_game.board[coordinates])
    @new_game.display
    coordinates
  end
end

game = Game.new
