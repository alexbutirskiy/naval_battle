require "pry"

require "./cell"
require "./ship"

class BoardSizeError < RuntimeError; end
class OutOfBoardError < RuntimeError; end
class ShipSizeError < RuntimeError; end
class NotRoomError < RuntimeError; end

class Board

  include Direction
  include State

  def initialize size_x=10, size_y=10
    raise BoardSizeError, "size should be in (1..20) range" unless (1..20).include? size_x
    raise BoardSizeError, "size should be in (1..20) range" unless (1..20).include? size_y
    @size_x = size_x; @size_y = size_y
    @cells = []
    @ships = []
    @alphabet = ""
    ("A".."Z").each {|a| @alphabet << a}

    0.upto(size_x - 1) do |x|
      @cells[x] = []
      0.upto(size_y - 1) { |y| @cells[x][y] = Cell.new(x, y) }
    end
  end

  def cell(col, row)
    @cells[col][row]
  end

  def put_ship head_x, head_y, size, dir
    raise OutOfBoardError, "head_x should be in (1..20) range" unless (0..@size_x-1).include? head_x
    raise OutOfBoardError, "head_y should be in (1..20) range" unless (0..@size_y-1).include? head_y
    raise ShipSizeError, "Ship size should be in range (1..5)" unless (1..5).include? size

#it makes list of cells which will be occupied by ship
#and checks for board border crossing
    cell_list = []
    x = head_x; y = head_y
    size.times do |i|
      case dir
      when NORTH
        raise NotRoomError if y == 0 && i != size-1
        cell_list[i] = [x,y]
        y -= 1
      when EAST 
        raise NotRoomError if x == @size_x-1 && i != size-1
        cell_list[i] = [x,y]
        x += 1
      when SOUTH 
        raise NotRoomError if y == @size_y-1 && i != size-1
        cell_list[i] = [x,y]
        y += 1
      when WEST
        raise NotRoomError if x == 0 && i != size-1
        cell_list[i] = [x,y]
        x -= 1
      end
    end
    
#it checks is thr nearest cells have already occupied
#algorithm isn't optimal because some cells is being checked many times
    cell_list.each do |x, y|
      raise NotRoomError, "Other ship is here" if cell(x,y).state != EMPTY
      if x != 0
        if ( cell(x-1,y).state != EMPTY ) \
          || ( y != 0 && cell(x-1,y-1).state != EMPTY ) \
          || ( y != @size_y-1 && cell(x-1,y+1).state != EMPTY )
          raise NotRoomError, "Other ship is near [#{x}:#{y}]" 
        end
      end
      if ( y != 0 && cell(x, y-1).state != EMPTY ) \
        || ( y != @size_y-1 && cell(x, y+1).state != EMPTY )
        raise NotRoomError, "Other ship is near [#{x}:#{y}]" 
      end
      if x != @size_x-1
        if ( cell(x+1,y).state != EMPTY ) \
          || ( y != 0 && cell(x+1,y-1).state != EMPTY ) \
          || ( y != @size_y-1 && cell(x+1,y+1).state != EMPTY )
          raise NotRoomError, "Other ship is near [#{x}:#{y}]" 
        end
      end
    end

    cell_list.each { |x, y| cell(x,y).state = SHIP }

  end

  def display str
    raise TypeError, "str should be Fixnum" unless str.class == Fixnum
    offset = 1
    res = ""
    case str
    when 0, 0 + @size_y + 1
      res << ' '
      (@size_x).times{|i| res << i.to_s}
      res << '  '
    when (offset..@size_y-1+offset)
      res << @alphabet[str - offset]
      @cells[str - offset].each do |c|
        case c.state
        when SHIP; res << '0'
        when BROKEN; res << 'X'
        when MISSED; res << '*'
        else res << ' '
        end
      end
      res << @alphabet[str - offset]
      res << ' '

    end

    res
  end

end


#LOOK is it good?
#Some unit tests
if $0 == __FILE__
b = Board.new 10, 10

b.put_ship 5, 5, 5, Direction::NORTH
b.put_ship 7, 6, 2, Direction::EAST
#        binding.pry
puts b

12.times do |i|
  puts b.display(i) << "   " << b.display(i)
end

end