require_relative 'chess_pieces'
require 'colorize'
require 'pry'

class Board
  def initialize
    @board = Array.new(72)
    @board.each_index do |index|
      @board[index] = if index.even?
                        '   '
                      else
                        '   '
                      end
      @players = [Player.new('Player 1', 'white'), Player.new('Player 2', 'black')]
      place_pieces(@players[0].color)
      place_pieces(@players[1].color)
    end
  end

  # method to place pieces in initial positions
  def place_pieces(color)
    i = if color == 'white'
          0
        else
          7
        end
    @board[i] = Rook.new(i, color)
    @board[i + 63] = Rook.new(i + 63, color)
    @board[i + 9] = Knight.new(i + 9, color)
    @board[i + 54] = Knight.new(i + 54, color)
    @board[i + 18] = Bishop.new(i + 18, color)
    @board[i + 45] = Bishop.new(i + 45, color)
    @board[i + 27] = Queen.new(i + 27, color)
    @board[i + 36] = King.new(i + 36, color)
    i = if color == 'white'
          0
        else
          5
        end
    [i + 1, i + 10, i + 19, i + 28, i + 37, i + 46, i + 55, i + 64].each do |j|
      @board[j] = Pawn.new(j, color)
    end
  end

  # method to display the board
  def display
    first_color = 'white'
    7.downto(0).each do |i|
      if first_color == 'white'
        print " #{i + 1} "
        print (@board[i]).to_s.black.on_light_white
        print (@board[i + 9]).to_s.black.on_light_black
        print (@board[i + 18]).to_s.black.on_light_white
        print (@board[i + 27]).to_s.black.on_light_black
        print (@board[i + 36]).to_s.black.on_light_white
        print (@board[i + 45]).to_s.black.on_light_black
        print (@board[i + 54]).to_s.black.on_light_white
        puts (@board[i + 63]).to_s.black.on_light_black
        first_color = 'black'
      else
        print " #{i + 1} "
        print (@board[i]).to_s.black.on_light_black
        print (@board[i + 9]).to_s.black.on_light_white
        print (@board[i + 18]).to_s.black.on_light_black
        print (@board[i + 27]).to_s.black.on_light_white
        print (@board[i + 36]).to_s.black.on_light_black
        print (@board[i + 45]).to_s.black.on_light_white
        print (@board[i + 54]).to_s.black.on_light_black
        puts (@board[i + 63]).to_s.black.on_light_white
        first_color = 'white'
      end
    end
    print '   ' + ' a ' + ' b ' + ' c ' + ' d ' + ' e ' + ' f ' + ' g ' + ' h '
    print "\n"
  end

  # method to translate coordonates(c3 for instance) into index
  def find_index(coordinates)
    coordinates = coordinates.split("")
    if coordinates[0] > 'h' || coordinates[0] < 'a' || coordinates[1] < '1' || coordinates[1] > '8'
      return nil
    else
      (coordinates[0].ord - 97) * 9 + coordinates[1].to_i - 1
    end
  end
end

class Player
  attr_accessor :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end
end

new_board = Board.new
new_board.display
