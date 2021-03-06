require 'colorize'

class Piece
  attr_accessor :position, :moves, :color, :edges, :first_round, :symbol

  def initialize(position, color, first_round = true)
    @position = position
    @color = color
    @edges = []
    @moves = []
    @first_round = first_round
  end

  def to_s
    @symbol
  end

  def diagonal_moves_right(position)
    diagonal_right_up = []
    diagonal_right_down = []
    x = position[0]
    y = position[1]
    until x > 7 || y > 7
      diagonal_right_up.push([x, y])
      x += 1
      y += 1
    end
    x = position[0]
    y = position[1]
    until x > 7 || y < 0
      diagonal_right_down.push([x, y])
      x += 1
      y -= 1
    end
    diagonal_right_up.delete(position)
    diagonal_right_down.delete(position)
    [diagonal_right_up, diagonal_right_down]
  end

  def diagonal_moves_left(position)
    diagonal_left_up = []
    diagonal_left_down = []
    x = position[0]
    y = position[1]
    until x < 0 || y > 7
      diagonal_left_up.push([x, y])
      x -= 1
      y += 1
    end
    x = position[0]
    y = position[1]
    until x < 0 || y < 0
      diagonal_left_down.push([x, y])
      x -= 1
      y -= 1
    end
    diagonal_left_up.delete(position)
    diagonal_left_down.delete(position)
    [diagonal_left_up, diagonal_left_down]
  end

  def horizontal_moves(position)
    horizontal_moves_right = []
    horizontal_moves_left = []
    (position[0]..7).each do |i|
      horizontal_moves_right.push([i, position[1]])
    end
    position[0].downto(0).each do |i|
      horizontal_moves_left.push([i, position[1]])
    end
    horizontal_moves_right.delete(position)
    horizontal_moves_left.delete(position)
    [horizontal_moves_right, horizontal_moves_left]
  end

  def vertical_moves(position)
    vertical_moves_up = []
    vertical_moves_down = []
    (position[1]..7).each do |i|
      vertical_moves_up.push([position[0], i])
    end
    position[1].downto(0).each do |i|
      vertical_moves_down.push([position[0], i])
    end
    vertical_moves_up.delete(position)
    vertical_moves_down.delete(position)
    [vertical_moves_up, vertical_moves_down]
  end

  def knight_king_pawn_moves
    @moves.each do |move|
      if move[0] > 7 || move[0] < 0 || move[1] > 7 || move[1] < 0
        next
      else
        @edges.push(move)
      end
    end
    @edges.delete(nil)
  end
end

class Block < Piece
  def initialize(position, color)
    @position = position
    @color = color
  end
end

class EmptyCell < Piece
  def initialize(position)
    @position = position
    @symbol = '   '
    @color = 'none'
  end
end

class Dot < Piece
  def initialize(position)
    @position = position
    @symbol = " \u00B7 "
    @color = 'none'
  end
end

class Knight < Piece
  attr_accessor :edges

  def initialize(position, color, first_round = true)
    super
    @symbol = if color == 'white'
                " \u2658 "
              else
                " \u265E "
              end
    @moves = [[position[0] - 2, position[1] - 1], [position[0] - 2, position[1] + 1],
              [position[0] - 1, position[1] - 2], [position[0] - 1, position[1] + 2],
              [position[0] + 1, position[1] - 2], [position[0] + 1, position[1] + 2],
              [position[0] + 2, position[1] - 1], [position[0] + 2, position[1] + 1]]
    @edges = Array.new(8)
    knight_king_pawn_moves
  end

  def update
    @moves = [[@position[0] - 2, @position[1] - 1], [@position[0] - 2, @position[1] + 1],
              [@position[0] - 1, @position[1] - 2], [@position[0] - 1, @position[1] + 2],
              [@position[0] + 1, @position[1] - 2], [@position[0] + 1, @position[1] + 2],
              [@position[0] + 2, @position[1] - 1], [@position[0] + 2, @position[1] + 1]]
    @edges = Array.new(8)
    knight_king_pawn_moves
  end
end

class Rook < Piece
  def initialize(position, color, first_round = true)
    super
    @symbol = if color == 'white'
                " \u2656 "
              else
                " \u265C "
              end
    @moves = vertical_moves(position) + horizontal_moves(position)
    @moves.delete([])
  end

  def update
    @edges = []
    @moves = vertical_moves(@position) + horizontal_moves(@position)
    @moves.delete([])
  end
end

class Bishop < Piece
  def initialize(position, color, first_round = true)
    super
    @symbol = if color == 'white'
                " \u2657 "
              else
                " \u265D "
              end
    @moves = diagonal_moves_right(@position) + diagonal_moves_left(@position)
    @moves.delete([])
  end

  def update
    @edges = []
    @moves = diagonal_moves_right(position) + diagonal_moves_left(position)
    @moves.delete([])
  end
end

class Queen < Piece
  def initialize(position, color, first_round = true)
    super
    @symbol = if color == 'white'
                " \u2655 ".on_white
              else
                " \u265B "
              end
    @moves = diagonal_moves_right(position) + diagonal_moves_left(position) + vertical_moves(position) + horizontal_moves(position)
    @moves.delete([])
  end

  def update
    @edges = []
    @moves = diagonal_moves_right(@position) + diagonal_moves_left(@position) + vertical_moves(@position) + horizontal_moves(@position)
    @moves.delete([])
  end
end

class King < Piece
  def initialize(position, color, first_round = true)
    super
    @symbol = if color == 'white'
                " \u2654 "
              else
                " \u265A "
              end
    @moves = [[position[0], position[1] + 1], [position[0], position[1] - 1],
              [position[0] + 1, position[1]], [position[0] - 1, position[1]],
              [position[0] + 1, position[1] + 1], [position[0] - 1, position[1] - 1],
              [position[0] - 1, position[1] + 1], [position[0] + 1, position[1] - 1]]
    knight_king_pawn_moves
  end

  def update
    @moves = [[@position[0], @position[1] + 1], [@position[0], @position[1] - 1],
              [@position[0] + 1, @position[1]], [@position[0] - 1, @position[1]],
              [@position[0] + 1, @position[1] + 1], [@position[0] - 1, @position[1] - 1],
              [@position[0] - 1, @position[1] + 1], [@position[0] + 1, @position[1] - 1]]
    @edges = []
    knight_king_pawn_moves
  end
end

class Pawn < Piece
  attr_accessor :first_round

  def initialize(position, color, first_round = true)
    super
    @symbol = if color == 'white'
                " \u2659 "
              else
                " \u265F "
              end
    @moves = find_moves
    @edges = []
    knight_king_pawn_moves
  end

  def update
    @edges = []
    @moves = find_moves
    knight_king_pawn_moves
  end

  def find_moves
    i = @color == 'white' ? 1 : -1
    [[@position[0], @position[1] + i], [@position[0], @position[1] + 2 * i],
     [@position[0] - 1, @position[1] + i], [@position[0] + 1, @position[1] + i]]
  end
end
