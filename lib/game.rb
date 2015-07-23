require 'pry'

require_relative  'board.rb'

## Default setting constants
module Defaults
  SIZE_X = 20
  SIZE_Y = 10
  PLAYER_1_NAME   = 'Player 1'
  PLAYER_2_NAME   = 'Player 2'
  PLAYER_NAME     = 'Human'
  COMPUTER_NAME   = 'Computer'
  COMPUTER_1_NAME = 'Computer 1'
  COMPUTER_2_NAME = 'Computer 2'

  SHIP_1_COUNT = 5
  SHIP_2_COUNT = 4
  SHIP_3_COUNT = 3
  SHIP_4_COUNT = 2
  SHIP_5_COUNT = 1

  SHIPS_COUNT = [SHIP_1_COUNT, SHIP_2_COUNT, SHIP_3_COUNT,
                 SHIP_4_COUNT, SHIP_5_COUNT]
end

# Main game class
# Use Game.new.run
class Game
  include Defaults
  def initialize(name_0 = PLAYER_NAME, name_1 = COMPUTER_NAME)
    @alphabet = ('A'..'Z').map { |a| a }
    @board = [Board.new(SIZE_X, SIZE_Y, name_0),
              Board.new(SIZE_X, SIZE_Y, name_1)]
    @board[0].generate(*SHIPS_COUNT)
    @board[1].generate(*SHIPS_COUNT)
    @delay = 1 * 0.2
    @current_player = 0
    @player_name = [name_0, name_1]
    @auto = :OFF
  end

  def display(b1, b2, hide_0 = false, hide_1 = false)
    system('clear')
    (SIZE_Y + 5).times do |i|
      puts b1.display(i, hide_0) << ' ' * 3 << b2.display(i, hide_1)
    end
    puts "Turn: #{@player_name[@current_player]}"
  end


  def random_shoot
    1000.times do
      shoot = [rand(SIZE_X), rand(SIZE_Y)]
      result = @board[@current_player - 1].shoot(*shoot)
      if result != 'ALREADY SHOT'
        return [result, shoot]
      end
    end
    fail
  end

  def human_shoot
    loop do
      print 'Enter the cell: '
      inp = gets.chop.upcase
      if inp == 'QUIT' then return ['QUIT', [0,0]] end
      if inp == 'AUTO' then return ['AUTO', [0,0]] end
      x = ('A'..'Z').to_a.index inp[0]
      y = inp.scan(/\d+/).first
      if x == nil || y == nil
        puts 'Wrong format. Example: E5'
        next
      end

      begin
        result = @board[@current_player - 1].shoot(x, y.to_i)
      rescue OutOfBoardError
        puts 'You have shot out of board. Try again.'
        next
      end

      if result == 'ALREADY SHOT'
        puts 'You have already shot there. Try again'
        next
      end
      return [result, [x,y]]
    end
  end

  def shoot 

    @auto == :ON ? random_shoot : human_shoot

  end

  def process_result(result)
    case result
    when 'MISSED'
      @current_player == 0 ? (@current_player = 1) : (@current_player = 0)
    when 'INJURED'
      sleep(@delay)
    when 'KILLED'
      if @board[@current_player - 1].is_ship_alive? == false
        congratulation @player_name[@current_player]
        return 'GAME OVER'
      end
      sleep(@delay)
    when 'QUIT'
      return 'QUIT'
    end
    sleep(@delay)
  end

  def congratulation(name)
    puts "\nCONGRATULATION!!!"
    puts "#{name} has won"
    puts 'GAME OVER'
    sleep(2)
  end

  def comp_vs_comp
    @board[0].player_name = COMPUTER_1_NAME
    @board[1].player_name = COMPUTER_2_NAME
    display(*@board)
    loop do
      result, hit = (@auto == :OFF ? human_shoot : random_shoot)
      return if result == 'QUIT'
      if result == 'AUTO'
        @auto = :ON
        next
      end
      display(*@board)
      puts "Hit: #{@alphabet[hit[0]]}#{hit[1]} - #{result}"
      return if process_result(result) == 'GAME OVER'
    end
  end

  def human_vs_comp
    @board[0].player_name = PLAYER_NAME
    @board[1].player_name = COMPUTER_NAME
    system('clear')
    print 'Enter your name: '
    name = gets.chop
    @player_name[0] = @board[0].player_name = name if name.length != 0
    display(*@board, false, true)
    loop do
      result, hit = (@current_player == 0 ? human_shoot : random_shoot)
      return if result == 'QUIT'

      display(*@board, false, true)
      puts "Hit: #{@alphabet[hit[0]]}#{hit[1]} - #{result}"
      return if process_result(result) == 'GAME OVER'
    end
  end



  def human_vs_human
    @board[0].player_name = PLAYER_1_NAME
    @board[1].player_name = PLAYER_2_NAME
    system('clear')
    print 'Enter Players 1 name: '
    name = gets.chop
    @player_name[0] = @board[0].player_name = name if name.length != 0
    print 'Enter Players 2 name: '
    name = gets.chop
    @player_name[1] = @board[1].player_name = name if name.length != 0
    player_last = -1
    hit = nil
    result = nil
    loop do
      if player_last != @current_player
        player_last = @current_player
        display(*@board, true, true)
        
        puts 'Press Enter when ready'
        gets
      end

      @current_player == 0 ? display(*@board, false, true) : display(*@board, true, false)
      puts "Hit: #{@alphabet[hit[0]]}#{hit[1]} - #{result}" if hit != nil && result != nil
      result, hit = human_shoot
      return if result == 'QUIT'
      @current_player == 0 ? display(*@board, false, true) : display(*@board, true, false)
      puts "Hit: #{@alphabet[hit[0]]}#{hit[1]} - #{result}"
      return if process_result(result) == 'GAME OVER'
    end
  end

  def run
    system('clear')
    greeting
    input = gets.chop
    case input
    when '1' then comp_vs_comp
    when '2' then human_vs_comp
    when '3' then human_vs_human
    when 'q', 'Q' then
    end
  end

  private

  def greeting
    puts "\n\n\n************** NAVAL BATTLE****************"
    puts 'Choose game mode:'
    puts '1 - Computer vs Computer'
    puts '2 - Human vs Computer'
    puts '3 - Human vs Human'
    puts
  end
end
