require "pry"

require "./cell"
require "./ship"

class Board

  include Direction

  def initialize size_x=10, size_y=10

#It creates multidimensional hash. Ruby is fantastic!!!
@cells = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }

@alphabet = ""
#It makes an empty board
    "A".upto("Z") do |y|
      size_y > 0 ? (size_y -= 1) : break
      @alphabet << y
      0.upto(size_x-1) { |x| @cells[y.to_sym][x.to_s.to_sym] = Cell.new }
    end
    binding.pry
  end

  def cell(row, col)
    raise ArgumentError, "[#{row}#{col}] #{row}i s out of range" unless @cells.has_key? row.to_sym
    raise ArgumentError, "[#{row}#{col}] #{col} is out of range" unless @cells[row.to_sym].has_key? col.to_sym
    @cells[row.to_sym][col.to_sym]
  end

  def put_ship size, head, dir
    raise ArgumentError, "Ship size should be in range (1..5)" unless (1..5).include? size
    raise TypeError, 'Ship head should be a Cell class type' unless (head.class == Cell)

#it makes cells list which will be occupied by ship
    size.times do
      
    end

  end


end


#LOOK is it good?
#Some unit tests
if $0 == __FILE__
b = Board.new
b.put_ship 3, Cell.new, Direction::NORTH
        binding.pry
puts b

end