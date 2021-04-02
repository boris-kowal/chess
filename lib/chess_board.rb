require_relative 'chess_pieces'
require 'colorize'
require 'pry'

class Board
  attr_accessor :board, :players, :origin, :destination, :king, :attacker

  def initialize
    @board = {}
    (0..7).each do |i|
      (0..7).each do |j|
        @board[[i, j]] = EmptyCell.new([i, j])
      end
    end
    @origin = Block.new([0, 0], 'white')
    @destination = Block.new([0, 0], 'white')
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
    coordinates = coordinates.downcase.split('')
    if !coordinates[0].match(/[a-h]/) || !coordinates[1].match(/[1-8]/)
      nil
    else
      [coordinates[0].ord - 97, coordinates[1].to_i - 1]
    end
  rescue StandardError
    nil
  end

  def find_position(coordinates)
    "#{(97 + coordinates[0]).chr}#{coordinates[1] + 1}"
  end

  def find_edges_rook_queen_bishop(piece)
    piece.update
    piece.moves.each do |array|
      array.each do |position|
        element = @board[position]
        if element.instance_of?(EmptyCell)
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
    x = piece.position[0]
    y = piece.position[1]
    begin
      piece.edges.delete([x, y + 2 * i]) if piece.first_round == false || @board[[x, y + 2 * i]].class != EmptyCell
      if @board[[x, y + i]].class != EmptyCell
        piece.edges.delete([x, y + i])
        piece.edges.delete([x, y + 2 * i])
      end
      if @board[[x + 1,
                 y + i]].instance_of?(EmptyCell) || (@board[[x + 1,
                                                             y + i]].class != EmptyCell && @board[[x + 1,
                                                                                                   y + i]].color == piece.color)
        piece.edges.delete([x + 1, y + i])
      end
      if @board[[x - 1,
                 y + i]].instance_of?(EmptyCell) || (@board[[x - 1,
                                                             y + i]].class != EmptyCell && @board[[x - 1,
                                                                                                   y + i]].color == piece.color)
        piece.edges.delete([x - 1, y + i])
      end
    rescue StandardError => e
      piece.edges.delete([x - 1, y + i])
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
    en_passant
    short_castle
    long_castle
  end

  def attacked_squares(color)
    attacked_squares = Hash.new { |hsh, key| hsh[key] = [] }
    @board.each_value do |element|
      if element.instance_of?(EmptyCell) || element.color != color
        next
      else
        element.edges.each do |position|
          attacked_squares[element].push(position)
        end
      end
    end
    attacked_squares
  end

  def escape_check(attacked)
    attacked.each do |key, value|
      value.each do |position|
        move_pieces(key.position, position)
        find_available_moves
        if !check?
          puts "#{find_position(@origin.position)} -> #{find_position(@destination.position)}"
          return
        else
          reverse_move
          find_available_moves
        end
      end
    end
  end



  def find_moves(color)
    @board.each_value do |element|
      if element.instance_of?(EmptyCell) || element.color != color
        next
      elsif [King, Knight].include?(element.class)
        find_edges_knight_king(element)
      elsif element.instance_of?(Pawn)
        find_edges_pawn(element)
      else
        find_edges_rook_queen_bishop(element)
      end
    end
  end

  def en_passant
    i = @origin.color == 'black' ? 1 : -1
    x = @destination.position[0]
    y = @destination.position[1]
    if (@origin.position[1] - @destination.position[1]).abs < 2 && @origin.instance_of?(Pawn)
      nil
    else
      @board[[x + i, y]].edges.push([x, y + i]) if @board[[x + i, y]].instance_of?(Pawn)
      @board[[x - i, y]].edges.push([x, y + i]) if @board[[x - i, y]].instance_of?(Pawn)
    end
  end

  def en_passant_move
    i = @origin.color == 'white' ? 1 : -1
    if @origin.instance_of?(Pawn) && @destination.position[0] != @origin.position[0] && @destination.instance_of?(EmptyCell)
      @board[[@destination.position[0], @destination.position[1] - i]] =
        EmptyCell.new([@destination.position[0], @destination.position[1] - i])
    end
  end

  def promote
    if (@destination.position[1] == 7 || @destination.position[1] == 0) && @origin.instance_of?(Pawn)
      puts 'please enter a piece to promote your pawn'
      puts '[1] Queen'
      puts '[2] Rook'
      puts '[3] Bishop'
      puts '[4] Knight'
      input = gets.chomp
      until input.match(/[1-4]/)
        puts 'please enter a correct input'
        input = gets.chomp
      end
      ['X', Queen, Rook, Bishop, Knight].each_with_index do |element, index|
        if index == input.to_i
          @origin = element.new(@origin.position, @origin.color)
          return
        else
          next
        end
      end
    end
  end

  def short_castle
    i = @origin.color == 'black' ? 0 : 7
    if @board[[7,
               i]].first_round != true || @board[[4,
                                                  i]].first_round != true || @board[[5,
                                                                                     i]].class != EmptyCell || @board[[
                                                                                       6, i
                                                                                     ]].class != EmptyCell || check?
      nil
    else
      @board[[5, i]] = King.new([5, i], @board[[7, i]].color)
      if check?
        @board[[5, i]] = EmptyCell.new([5, i])
        return nil
      end
      @board[[5, i]] = EmptyCell.new([5, i])
      @board[[6, i]] = King.new([6, i], @board[[7, i]].color)
      if check?
        @board[[6, i]] = EmptyCell.new([6, i])
        nil
      else
        @board[[4, i]].edges.push([6, i])
        @board[[6, i]] = EmptyCell.new([6, i])
      end
    end
  end

  def castle_move
    i = @origin.color == 'white' ? 0 : 7
    if @origin.instance_of?(King) && (@destination.position[0] - @origin.position[0]).abs > 1 && @destination.position == [
      6, i
    ]
      @board[[5, i]] = Rook.new([5, i], @origin.color, false)
      @board[[7, i]] = EmptyCell.new([7, i])
    elsif @origin.instance_of?(King) && (@destination.position[0] - @origin.position[0]).abs > 1 && @destination.position == [
      1, i
    ]
      @board[[3, i]] = Rook.new([2, i], @origin.color, false)
      @board[[0, i]] = EmptyCell.new([0, i])
    end
  end

  def long_castle
    i = @origin.color == 'black' ? 0 : 7
    if @board[[0,
               i]].first_round != true || @board[[4,
                                                  i]].first_round != true || @board[[1,
                                                                                     i]].class != EmptyCell || @board[[
                                                                                       2, i
                                                                                     ]].class != EmptyCell || @board[[
                                                                                       3, i
                                                                                     ]].class != EmptyCell || check?
      nil
    else
      @board[[2, i]] = King.new([2, i], @board[[0, i]].color)
      if check?
        @board[[2, i]] = EmptyCell.new([2, i])
        return nil
      else
        @board[[2, i]] = EmptyCell.new([2, i])
      end
      @board[[3, i]] = King.new([3, i], @board[[0, i]].color)
      if check?
        @board[[3, i]] = EmptyCell.new([3, i])
        return nil
      else
        @board[[3, i]] = EmptyCell.new([3, i])
      end
      @board[[1, i]] = King.new([1, i], @board[[0, i]].color)
      if check?
        @board[[1, i]] = EmptyCell.new([1, i])
        nil
      else
        @board[[4, i]].edges.push([1, i])
        @board[[1, i]] = EmptyCell.new([1, i])
      end
    end
  end

  def checkmate?(king, attacker)
    find_available_moves
    attacked = attacked_squares(attacker.color)
    king.edges.each do |position|
      if !attacked.has_value?(position)
        move_pieces(king.position, position)
        find_available_moves
        unless check?
          reverse_move
          find_available_moves
          return false
        end
        reverse_move
        find_available_moves
      else
        next
      end
    end
    attacked = attacked_squares(king.color)
    attacked.each do |key, value|
      if value.include?(attacker.position)
        move_pieces(key.position, attacker.position)
        find_available_moves
        unless check?
          reverse_move
          find_available_moves
          return false
        end
      else
        next
      end
      reverse_move
      find_available_moves
    end
    attacked.each do |key, array|
      array.each do |position|
        move_pieces(key.position, position)
        find_moves(attacker.color)
        if check?
          reverse_move
          find_available_moves
          next
        else
          reverse_move
          return false
        end
      end
    end
    true
  end

  def check?
    check_color?('white') || check_color?('black')
  end

  def check_color?(color)
    @board.each_value do |element|
      next if element.edges.nil? || element.color == color

      element.edges.each do |position|
        piece = @board[position]
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

  def move_pieces(from, to)
    @origin = @board[from]
    @destination = @board[to]
    if !@origin.edges.include?(@destination.position) || @destination.color == @origin.color
      'Illegal move'
    else
      en_passant_move if @origin.class == Pawn
      promote if @origin.class == Pawn
      castle_move if @origin.class == King
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
