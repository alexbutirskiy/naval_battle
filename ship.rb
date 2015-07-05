require "./cell"

module Direction
  NORTH = 0
  EAST  = 1
  SOUTH = 2
  WEST  = 3
end

class Ship
  include State
  def initialize (*cells)
    @cells = cells
  end

  def is_alive?
    @cells.each { |c| if c.state == SHIP then return true end }
    false
  end

end



#Some unit tests
if $0 == __FILE__

s = Ship.new  Cell.new(State::SHIP), Cell.new(State::SHIP), Cell.new(State::SHIP) 

binding.pry
puts b
end