require_relative  'cell'
require_relative  'ship'

class BoardSizeError < RuntimeError; end
class OutOfBoardError < RuntimeError; end
class ShipSizeError < RuntimeError; end
class NotRoomError < RuntimeError; end

# class Board describes game board
class Board
  include Direction
  include State

  attr_accessor :player_name

  def initialize(size_x = 10, size_y = 10, name = '')
    unless (1..20).include?(size_x) && (1..20).include?(size_y)
      fail BoardSizeError, 'size should be in (1..20) range'
    end

    @size_x, @size_y, @player_name = size_x, size_y, name

    @cells, @ships = [], []

    @alphabet = ('A'..'Z').map { |a| a }

    0.upto(size_x - 1) do |x|
      @cells[x] = []
      0.upto(size_y - 1) { |y| @cells[x][y] = Cell.new(x, y) }
    end
  end

  def cell(col, row)
    @cells[col][row]
  end

  def put_ship(head_x, head_y, size, dir)
    head_x, head_y  = x_y_normalize head_x, head_y

    unless (1..5).include? size
      fail ShipSizeError, 'Ship size should be in range (1..5)'
    end

    # it makes list of cells which will be occupied by ship
    # and checks for board border crossing
    cell_list = []
    x = head_x
    y = head_y
    size.times do |i|
      case dir
      when NORTH
        fail NotRoomError if y == 0 && i != size - 1
        cell_list[i] = [x, y]
        y -= 1
      when EAST
        fail NotRoomError if x == 0 && i != size - 1
        cell_list[i] = [x, y]
        x -= 1
      when SOUTH
        fail NotRoomError if y == @size_y - 1 && i != size - 1
        cell_list[i] = [x, y]
        y += 1
      when WEST
        fail NotRoomError if x == @size_x - 1 && i != size - 1
        cell_list[i] = [x, y]
        x += 1
      end
    end

    # it checks if the nearest cells have already been occupied
    # algorithm isn't optimal because some cells are being checked many times
    cell_list.each do |x, y|
      fail NotRoomError, 'Other ship is here' if cell(x, y).state != EMPTY
      if x != 0
        if  (cell(x - 1, y).state != EMPTY) ||
            (y != 0 && cell(x - 1,  y - 1).state != EMPTY) ||
            (y != @size_y - 1 && cell(x - 1, y + 1).state != EMPTY)
          fail NotRoomError, "Other ship is near [#{x}:#{y}]"
        end
      end
      if  (y != 0 && cell(x, y - 1).state != EMPTY) ||
          (y != @size_y - 1 && cell(x, y + 1).state != EMPTY)
        fail NotRoomError, "Other ship is near [#{x}:#{y}]"
      end
      if x != @size_x - 1
        if  (cell(x + 1, y).state != EMPTY) ||
            (y != 0 && cell(x + 1, y - 1).state != EMPTY) ||
            (y != @size_y - 1 && cell(x + 1, y + 1).state != EMPTY)
          fail NotRoomError, 'Other ship is near [#{x}:#{y}]'
        end
      end
    end

    @ships << Ship.new(cell_list.map { |x, y|  cell x, y })
  end

  def shoot(x, y)
    # there is a posibility of using letters as X coordinate
    x, y = x_y_normalize x, y
    c = cell(x, y)
    case c.state
    when EMPTY
      c.state = MISSED
      return 'MISSED'
    when SHIP
      ship = @ships.find { |sh| sh.include? c }
      fail FatalError, 'Mismatch between cell and ship tables' if ship.nil?
      c. state = BROKEN
      ship.alive? ? (return 'INJURED') : (return 'KILLED')
    when MISSED, BROKEN
      return 'ALREADY SHOT'
    end
  end

  def is_ship_alive?
    @ships.each { |sh| return true if sh.alive? }
    false
  end

  def display(str, hide_ships = false)
    fail TypeError, 'str should be Fixnum' unless str.class == Fixnum
    offset = 2
    res = ''
    case str
    when 0
      res << @player_name.center(@size_x + 4)
      res << ' '
    when 1, 1 + @size_y + 1
      res << ' ' * 2
      (@size_x).times { |i| res << @alphabet[i] }
      res << ' ' * 3
    when (offset..@size_y - 1 + offset)
      res << (@size_y - 1 - (str - offset)).to_s
      res << '|'
      @size_x.times do |x|
        case @cells[x][@size_y - 1 - (str - offset)].state
        when SHIP then hide_ships ? (res << ' ') : (res << 'O')
        when BROKEN then res << 'X'
        when MISSED then res << '*'
        else res << ' '
        end
      end
      res << '|'
      res << (@size_y - 1 - (str - offset)).to_s
      res << ' '
    end
    res
  end

  def generate(*list)
    5.downto(1).each do |size|
      count = list[size - 1]
      count.times do
        100.times do |try|
          begin
            head_x = rand(@size_x)
            head_y = rand(@size_y)
            dir = rand(4)
            put_ship head_x, head_y, size, dir
            break
          rescue NotRoomError
            raise NotRoomError, 'Too much ships' if try == 100 - 1
          end
        end
      end
    end
  end

  private

  # it converts x to number if it is a letter
  # then validates them
  # returns x, y
  def x_y_normalize(x, y)
    x = @alphabet.index(x.upcase) if x.is_a?(String)
    p = x_y_normalize_params
    fail OutOfBoardError, "x should be in range #{p[:x_n]} or #{p[:x_l]}"\
      unless (0..@size_x - 1).include? x
    fail OutOfBoardError, "y should be in range #{p[:y]}"\
      unless (0..@size_y - 1).include? y
    [x, y]
  end

  def x_y_normalize_params
    {
      x_n:  "(0..#{@size_x - 1})",
      x_l:  "(\"A\"..\"#{@alphabet[@size_x - 1]}\"))",
      y:    "(0..#{@size_x - 1})"
    }
  end
end
