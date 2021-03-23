class Piece
  attr_accessor :position
  def initialize(position, color)
    @position = position
    @color = color
  end

  def to_s
    @symbol
  end
end

class Knight < Piece
  def initialize(position, color)
    super(position, color)
    if color == 'white'
      @symbol = " \u2658 "
    else
      @symbol = " \u265E "
    end
  end
end

class Rook < Piece
  def initialize(position, color)
   super(position, color)
   if color == 'white'
    @symbol = " \u2656 "
  else
    @symbol = " \u265C "
  end
  end
end

class Bishop < Piece
  def initialize(position, color)
    super(position, color)
    if color == 'white'
      @symbol = " \u2657 "
    else
      @symbol = " \u265D "
    end
  end
end

class Queen < Piece
  def initialize(position, color)
    super
    if color == 'white'
      @symbol = " \u2655 "
    else
      @symbol = " \u265B "
    end
  end
end

class King < Piece
  def initialize(position, color)
    super(position, color)
    if color == 'white'
      @symbol = " \u2654 "
    else
      @symbol = " \u265A "
    end
  end
end

class Pawn < Piece
  def initialize(position, color)
    super(position, color)
    if color == 'white'
      @symbol = " \u2659 "
    else
      @symbol = " \u265F "
    end
  end
end
