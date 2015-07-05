require "pry"

require "./cell.rb"
require "./board"
require "./ship"


describe Cell, "class:" do

  let(:cell) {Cell.new 0, 0}

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
  it "raises TypeError if it tries to set wrong state" do
    expect{cell.state = -1}.to raise_error(TypeError)
    expect{cell.state = 10}.to raise_error(TypeError)
  end
  
end

describe Board, "class:" do
  before :each do
    @board = Board.new(10, 10)
  end

  # context "#cell method" do
  #   it "reurns cell if args are proper" do
  #     expect( @board.cell("A", "0").class ).to eq Cell
  #   end
  #   it "raises ArgumentError when args are out of range" do
  #     expect{ @board.cell("K", "0").class }.to raise_error(ArgumentError)
  #     expect{ @board.cell("A", "10").class }.to raise_error(ArgumentError)
  #     expect{ @board.cell("0", "A").class }.to raise_error(ArgumentError)
  #   end
  # end

   context "#put_ship method" do

    it "puts a ship when it's args are proper" do
      expect{ @board.put_ship 0, 0, 1, Direction::NORTH }.to_not raise_error
      expect{ @board.put_ship 0, 9, 1, Direction::EAST  }.to_not raise_error
      expect{ @board.put_ship 9, 0, 1, Direction::SOUTH }.to_not raise_error
      expect{ @board.put_ship 9, 9, 1, Direction::WEST  }.to_not raise_error
      expect{ @board.put_ship 4, 5, 5, Direction::NORTH }.to_not raise_error
      expect{ @board.put_ship 6, 4, 5, Direction::SOUTH }.to_not raise_error
      expect{ @board.put_ship 6, 0, 2, Direction::EAST  }.to_not raise_error

    end

    it "raises OutOfBoardError when heads coordinates are wrong" do
      expect{ @board.put_ship -1, 0, 1, Direction::NORTH  }.to raise_error(OutOfBoardError)
      expect{ @board.put_ship  0,-1, 1, Direction::NORTH  }.to raise_error(OutOfBoardError)
      expect{ @board.put_ship 10, 0, 1, Direction::NORTH  }.to raise_error(OutOfBoardError)
      expect{ @board.put_ship  0,10, 1, Direction::NORTH  }.to raise_error(OutOfBoardError)
    end
    it "raises ShipSizeError when ship size is out of range (1..5)" do
      expect{ @board.put_ship 0, 0, 0, Direction::NORTH  }.to raise_error(ShipSizeError)
      expect{ @board.put_ship 9, 9, 6, Direction::SOUTH  }.to raise_error(ShipSizeError)
    end

  end





end