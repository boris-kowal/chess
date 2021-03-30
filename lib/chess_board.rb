require_relative 'chess_pieces'
require 'colorize'
require 'pry'

class Board
  attr_accessor :board, :players

  def initialize
    @board = Hash.new
    for i in 0..7
      for j in 0..7
        @board[[i, j]] = EmptyCell.new([i, j])
      end
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
    @board[[0, i]] = Rook.new([0, i], color)
    @board[[7, i]] = Rook.new([7, i], color)
    @board[[1, i]] = Knight.new([1, i], color)
    @board[[6, i]] = Knight.new([6, i], color)
    @board[[2, i]] = Bishop.new([2, i], color)
    @board[[5, i]] = Bishop.new([5, i], color)
    @board[[3, i]] = Queen.new([3, i], color)
    @board[[4, i]] = King.new([4, i], color)
    i = if color == 'white'
          0
        else
          5
        end
    [0, 1, 2, 3, 4, 5, 6, 7].each do |j|
      @board[[j, 1 + i]] = Pawn.new([j, 1 + i], color)
    end
  end

  # method to display the board
  def display
    first_color = 'white'
    7.downto(0).each do |i|
      if first_color == 'white'
        print " #{i + 1} "
        [0, 2, 4, 6].each do |j|
          print (@board[[j, i]]).to_s.black.on_light_white
          print (@board[[j + 1, i]]).to_s.black.on_light_black
        end
        print "\n"
        first_color = 'black'
      else
        print " #{i + 1} "
        [0, 2, 4, 6].each do |j|
          print (@board[[j, i]]).to_s.black.on_light_black
          print (@board[[j + 1, i]]).to_s.black.on_light_white
        end
        print "\n"
        first_color = 'white'
      end
    end
    print '   ' + ' a ' + ' b ' + ' c ' + ' d ' + ' e ' + ' f ' + ' g ' + ' h '
    print "\n"
  end

  # method to translate coordonates(c3 for instance) into index
  def find_coordinates(coordinates)
    begin
      coordinates = coordinates.downcase.split("")
      if !coordinates[0].match(/[a-h]/) || !coordinates[1].match(/[1-8]/)
        nil
      else
        [coordinates[0].ord - 97, coordinates[1].to_i - 1]
      end
    rescue
      nil
    end
  end

  def find_edges_rook_queen_bishop(piece)
    piece.update
    piece.moves.each do |array|
      array.each do |position|
        element = @board[position]
        if element.class == EmptyCell
          piece.edges.push(position)
        elsif element.color == piece.color
          break
        else
          piece.edges.push(position)
          break
        end
      end
    end
  end

  def find_edges_pawn(piece)
    piece.update
    i = piece.color == 'white' ? 1 : -1
    x, y = piece.position[0], piece.position[1]
    begin
      if piece.first_round == false || @board[[x, y + 2 * i]].class != EmptyCell
        piece.edges.delete([x, y + 2 * i])
      end
      if @board[[x, y + i]].class != EmptyCell
        piece.edges.delete([x, y + i])
        piece.edges.delete([x, y + 2 * i])
      end
      if @board[[x + 1, y + i]].class == EmptyCell || (@board[[x + 1, y + i]].class != EmptyCell && @board[[x + 1, y + i]].color == piece.color)
        piece.edges.delete([x + 1, y + i])
      end
      if @board[[x - 1, y + i]].class == EmptyCell || (@board[[x - 1, y + i]].class != EmptyCell && @board[[x - 1, y + i]].color == piece.color)
        piece.edges.delete([x - 1, y + i])
      end
    rescue => exception
      return
    end
  end

  def find_edges_knight_king(piece)
    to_remove = []
    piece.update
    piece.edges.each do |position|
      if @board[position].color == piece.color
        # binding.pry
        to_remove.push(position)
      end
    end
    piece.edges = piece.edges.difference(to_remove)
  end

  def find_available_moves
    find_moves('white')
    find_moves('black')
  end

  def attacked_squares(color)
    attacked_squares = Hash.new{|hsh,key| hsh[key] = [] }
    @board.each_value do |element|
      if element.class == EmptyCell || element.color != color
        next
      else
        element.edges.each do |position|
          attacked_squares[element].push(position)
        end
      end
    end
    attacked_squares
  end

  def find_moves(color)
    @board.each_value do |element|
      if element.class == EmptyCell || element.color != color
        next
      elsif [King, Knight].include?(element.class)
        find_edges_knight_king(element)
      elsif element.class == Pawn
        find_edges_pawn(element)
      else
        find_edges_rook_queen_bishop(element)
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
    @origin = @board[from]
    @destination = @board[to]
    if !@origin.edges.include?(@destination.position) || @destination.color == @origin.color
      'Illegal move'
    else
      @board[to] = @origin.class.new(@destination.position, @origin.color, false)
      @board[from] = EmptyCell.new(@origin.position)
    end
  end

  def reverse_move
    from = @origin.position
    to = @destination.position
    @board[to] = @destination
    @board[from] = @origin
    find_available_moves
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
# new_board.find_available_moves
# print new_board.attacked_squares('white')

