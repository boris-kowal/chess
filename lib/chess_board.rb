#require_relative 'chess_pieces.rb'
require 'colorize'
require 'pry'

class Board
  def initialize
    @board = Array.new(72)
    @board.each_index do |index|
      if index % 2 == 0
        @board[index] = "   ".on_white
      else
        @board[index] = "   ".on_light_black
      end
    end
  end

  def display
    for i in 7.downto(0) do
      print " #{i + 1} "
      print "#{@board[i]}"
      print "#{@board[i + 9]}"
      print "#{@board[i + 18]}"
      print "#{@board[i + 27]}"
      print "#{@board[i + 36]}"
      print "#{@board[i + 45]}"
      print "#{@board[i + 54]}"
      puts "#{@board[i + 63]}"
    end
    print "   " + " a " + " b " + " c " + " d "+ " e " + " f " + " g " + " h "
    print "\n"  
  end
end

new_board = Board.new
new_board.display