require 'pry'

# Describes cell states
module State
  EMPTY   = 0   # Nothing except sea water
  SHIP    = 1   # Occupied by ship
  BROKEN  = 2   # Occupied by broken ship
  MISSED  = 3   # There was a mishit here
end

# class Cell describes cell state
class Cell
  include State
  attr_accessor :state
  def initialize(col, row, st = EMPTY)
    @state = st
    @col = col
    @row = row
  end

  def state=(new_st)
    if (State.constants.collect { |sym| State.const_get sym }).include? new_st
      @state = new_st
    else
      fail TypeError
    end
  end

  def to_s
    "Cell [#{@col}:#{@row}] State = #{@state}"
  end
end
