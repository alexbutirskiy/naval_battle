require "pry"

require "./cell.rb"
require "./board"
require "./ship"


describe Cell, "class:" do

  let(:cell) {Cell.new "A", "0"}

  it "creates new instance with default state == EMPTY" do
    expect(cell.state).to eq State::EMPTY
  end

#LOOK is it good practic to put "it" inside loop?
  State.constants.each do |st|
    it "sets state #{st}" do
      #binding.pry
      cell.state = State.const_get(st)
      expect(cell.state).to eq State.const_get(st)
    end
  end

#LOOK is it good practic taste method on wrong args?
  it "raises TypeError if it tries to set to wrong state" do
    expect{cell.state = -1}.to raise_error(TypeError)
    expect{cell.state = 10}.to raise_error(TypeError)
  end
  
end

describe Board, "class:" do
  before :each do
    @board = Board.new(10, 10)
  end

  context "#cell method" do
    it "reurns cell if args are proper" do
      expect( @board.cell("A", "0").class ).to eq Cell
    end
    it "raises ArgumentError when args are out of range" do
      expect{ @board.cell("K", "0").class }.to raise_error(ArgumentError)
      expect{ @board.cell("A", "10").class }.to raise_error(ArgumentError)
      expect{ @board.cell("0", "A").class }.to raise_error(ArgumentError)
    end
  end

  context "#put_ship method" do

    it "puts a ship when it's args are proper" do
      @board.put_ship 1, @board.cell("A", "0"), Direction::NORTH
      @board.put_ship 1, @board.cell("A", "9"), Direction::EAST
      @board.put_ship 1, @board.cell("B", "0"), Direction::SOUTH
      @board.put_ship 1, @board.cell("B", "9"), Direction::WEST
      @board.put_ship 5, @board.cell("E", "0"), Direction::NORTH
      @board.put_ship 5, @board.cell("E", "2"), Direction::SOUTH
      @board.put_ship 5, @board.cell("B", "4"), Direction::NORTH
      @board.put_ship 5, @board.cell("H", "8"), Direction::NORTH
    end

    it "puts ship when it's size is right" do
      expect{ @board.put_ship 1, @board.cell("A", "0"), Direction::NORTH }.to_not raise_error
      expect{ @board.put_ship 5, @board.cell("A", "0"), Direction::NORTH }.to_not raise_error
    end

    it "raises ArgumentError when ship's size is wrong" do
      expect{ @board.put_ship 0, @board.cell("A", "0"), Direction::NORTH }.to raise_error(ArgumentError)
      expect{ @board.put_ship 6, @board.cell("A", "0"), Direction::NORTH }.to raise_error(ArgumentError)
    end
    it "raises when ship head is wrong" #do
      #expect{ @board.put_ship 1, @board.cell("K", "0"), Direction::NORTH }.to raise_error(ArgumentError)
      #expect{ @board.put_ship 1, @board.cell("A", "11"), Direction::NORTH }.to raise_error(ArgumentError)
    #end

  end





end