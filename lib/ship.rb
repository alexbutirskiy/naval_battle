require_relative  'cell'

# Ship direction constants
module Direction
  NORTH = 0
  EAST  = 1
  SOUTH = 2
  WEST  = 3
end

# class Ship describes ship state
class Ship
  include State
  def initialize(cells)
    @cells = cells
    @cells.each { |c| c.state = SHIP }
  end

  def alive?
    @cells.each { |c| return true if c.state == SHIP }
    false
  end

  def include?(cell)
    @cells.include? cell
  end
end
