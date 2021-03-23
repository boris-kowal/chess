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
    @symbol = " k "
  end
end

class Tower < Piece
  def initialize(position, color)
   super(position, color)
   @symbol = " T "
  end
end

class Bishop < Piece
  def initialize(position, color)
    super(position, color)
    @symbol = " B "
  end
end

class Queen < Piece
  def initialize(position, color)
    super
    @symbol = " Q "
  end
end

class King < Piece
  def initialize(position, color)
    super(position, color)
    @symbol = " K "
  end
end

class Pawn < Piece
  def initialize(position, color)
    super(position, color)
    @symbol = " P "
  end
end
