require "pry"
# Describes cell states
module State
  EMPTY   = 0   #Nothing except sea's water
  SHIP    = 1   #Occupied by ship
  BROKEN  = 2   #Occupied by broken ship
  MISSED  = 3   #There was missing shoot here
end

class Cell
  include State
  attr_accessor :state
  def initialize col, row, st = EMPTY
    @state = st; @col = col; @row = row
  end

  def state=(new_st)

#LOOK is this a good way to make "typedef enum"?
#It tastes if new_st is valid
    if (State.constants.collect {|sym| State.const_get sym}).include? new_st
      @state = new_st
    else
     raise TypeError#, "new state should be one of #{State.constants.collect{|s| s.to_s}}"
    end
  end

end


#Some unit tests
if $0 == __FILE__
cell = Cell.new

puts cell.state

cell.state = State::SHIP
end