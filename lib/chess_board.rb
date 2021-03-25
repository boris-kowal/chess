require_relative 'chess_pieces'
require 'colorize'
require 'pry'

class Board
  attr_accessor :board, :players

  def initialize
    @board = Array.new(72)
    @board.each_index do |index|
      @board[index] = EmptyCell.new(find_coordinates_from_index(index))
    end
      place_pieces('white')
      place_pieces('black')
  end

  # method to place pieces in initial positions
  def place_pieces(color)
    i = if color == 'white'
          0
        else
          7
        end
    @board[i] = Rook.new([0, i], color)
    @board[i + 63] = Rook.new([7, i], color)
    @board[i + 9] = Knight.new([1, i], color)
    @board[i + 54] = Knight.new([6, i], color)
    @board[i + 18] = Bishop.new([2, i], color)
    @board[i + 45] = Bishop.new([5, i], color)
    @board[i + 27] = Queen.new([3, i], color)
    @board[i + 36] = King.new([4, i], color)
    i = if color == 'white'
          0
        else
          5
        end
    [i + 1, i + 10, i + 19, i + 28, i + 37, i + 46, i + 55, i + 64].each_with_index do |j, index|
      @board[j] = Pawn.new([index, 1 + i], color)
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

  def find_index_from_array(coordinates)
    coordinates[0] * 9 + coordinates[1]
  end

  def find_coordinates_from_index(index)
    position = Array.new(2)
    position[0] = index / 9
    position[1] = index % 9
    position
  end

  def find_edges(piece)
    piece.moves.each do |array|
      array.each do |position|
        element = @board[find_index_from_array(position)]
        if element.class == EmptyCell
          piece.edges.push(position)
        elsif element.color == "white"
          break
        else
          piece.edges.push(position)
          break
        end
      end
    end
  end
  

  # def show_available_moves(node)
  #   binding.pry
  #   node.edges.each do |position|
  #     @board[find_index_from_array(position)] = " \u2022 "
  #   end
  # end

  def move_pieces(from, to)
    origin = @board[from]
    destination = @board[to]
    if !origin.edges.include?(destination.position) || destination.color == 'white'
      puts 'Illegal move'
    else
      @board[to] = origin.class.new(find_coordinates_from_index(to), origin.color)
      @board[from] = EmptyCell.new(origin.position)
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

# new_board = Board.new
# new_board.display
# #new_board.find_edges(new_board.board[28])
# new_board.move_pieces(9, 2)
# new_board.display
