require 'pry'

require_relative '../lib/cell.rb'
require_relative '../lib/board'
require_relative '../lib/ship'

describe Cell, 'lass:' do
  let(:cell) { Cell.new 0, 0 }

  it 'creates new instance with default state == EMPTY' do
    expect(cell.state).to eq State::EMPTY
  end

  State.constants.each do |st|
    it "sets state #{st}" do
      cell.state = State.const_get(st)
      expect(cell.state).to eq State.const_get(st)
    end
  end

  it 'raises TypeError if it tries to set wrong state' do
    expect { cell.state = -1 }.to raise_error(TypeError)
    expect { cell.state = 10 }.to raise_error(TypeError)
  end
end

describe Board, 'class:' do
  before :each do
    @board = Board.new(10, 10)
  end

  context '#put_ship method' do
    it 'puts a ship if its args are proper' do
      expect { @board.put_ship 'A', 0, 1, Direction::NORTH }.to_not raise_error
      expect { @board.put_ship 'A', 9, 1, Direction::EAST  }.to_not raise_error
      expect { @board.put_ship 'J', 0, 1, Direction::SOUTH }.to_not raise_error
      expect { @board.put_ship 'J', 9, 1, Direction::WEST  }.to_not raise_error
      expect { @board.put_ship 'E', 5, 5, Direction::NORTH }.to_not raise_error
      expect { @board.put_ship 'G', 4, 5, Direction::SOUTH }.to_not raise_error
      expect { @board.put_ship 'H', 0, 2, Direction::EAST  }.to_not raise_error
    end

    it 'raises OutOfBoardError if head coordinates are wrong' do
      expect { @board.put_ship(-1, 0, 1, Direction::NORTH)  }
        .to raise_error(OutOfBoardError)
      expect { @board.put_ship 0, (-1), 1, Direction::NORTH  }
        .to raise_error(OutOfBoardError)
      expect { @board.put_ship 10, 0, 1, Direction::NORTH  }
        .to raise_error(OutOfBoardError)
      expect { @board.put_ship 0, 10, 1, Direction::NORTH  }
        .to raise_error(OutOfBoardError)
    end
    it 'raises ShipSizeError if ship size is out of range (1..5)' do
      expect { @board.put_ship 'A', 0, 0, Direction::NORTH  }
        .to raise_error(ShipSizeError)
      expect { @board.put_ship 'A', 9, 6, Direction::SOUTH  }
        .to raise_error(ShipSizeError)
    end

    it 'raises NotRoomError if there is not enough room to place a ship' do
      expect { @board.put_ship 'D', 6, 5, Direction::SOUTH }
        .to raise_error(NotRoomError)
      expect { @board.put_ship 'D', 6, 5, Direction::EAST }
        .to raise_error(NotRoomError)
      expect { @board.put_ship 'G', 3, 5, Direction::NORTH }
        .to raise_error(NotRoomError)
      expect { @board.put_ship 'G', 3, 5, Direction::WEST  }
        .to raise_error(NotRoomError)
    end

    it 'raises NotRoomError if other ship is near' do
      @board.put_ship 'E', 4, 1, Direction::NORTH
      expect { @board.put_ship 'D', 3, 1, Direction::NORTH  }
        .to raise_error(NotRoomError)
      expect { @board.put_ship 'D', 4, 1, Direction::NORTH  }
        .to raise_error(NotRoomError)
      expect { @board.put_ship 'D', 5, 1, Direction::NORTH  }
        .to raise_error(NotRoomError)
      expect { @board.put_ship 'E', 3, 1, Direction::NORTH  }
        .to raise_error(NotRoomError)
      expect { @board.put_ship 'E', 4, 1, Direction::NORTH  }
        .to raise_error(NotRoomError)
      expect { @board.put_ship 'E', 5, 1, Direction::NORTH  }
        .to raise_error(NotRoomError)
      expect { @board.put_ship 'F', 3, 1, Direction::NORTH  }
        .to raise_error(NotRoomError)
      expect { @board.put_ship 'F', 4, 1, Direction::NORTH  }
        .to raise_error(NotRoomError)
      expect { @board.put_ship 'F', 5, 1, Direction::NORTH  }
        .to raise_error(NotRoomError)
    end
  end

  context '#shoot method' do
    it 'returns "MISSED" ' do
      expect(@board.shoot 'A', 0).to eq 'MISSED'
    end

    it 'returns "INJURED"' do
      @board.put_ship 'A', 0, 2, Direction::SOUTH
      expect(@board.shoot 'A', 0).to eq 'INJURED'
    end

    it 'returns "KILLED"' do
      @board.put_ship 'A', 0, 2, Direction::SOUTH
      expect(@board.shoot 'A', 0).to eq 'INJURED'
      expect(@board.shoot 'A', 1).to eq 'KILLED'
    end

    it 'returns "ALREADY SHOT"' do
      @board.put_ship 'A', 0, 2, Direction::SOUTH
      @board.shoot 'A', 0
      expect(@board.shoot 'A', 0).to eq 'ALREADY SHOT'
    end

    it 'raises OutOfBoardError if coordinates are wrong' do
      expect { @board.shoot(-1, 0) }.to raise_error(OutOfBoardError)
      expect { @board.shoot 10, 0 }.to raise_error(OutOfBoardError)
      expect { @board.shoot 0, (-1) }.to raise_error(OutOfBoardError)
      expect { @board.shoot 0, 10 }.to raise_error(OutOfBoardError)
    end
  end
end
