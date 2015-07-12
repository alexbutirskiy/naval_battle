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
  def initialize
    @alphabet = ''
    ('A'..'Z').each { |a| @alphabet << a }
  end

  def display(b1, b2)
    system('clear')
    (SIZE_Y + 5).times do |i|
      puts b1.display(i) << ' ' * 3 << b2.display(i)
    end
  end

  def comp_vs_comp
    board = [Board.new(SIZE_X, SIZE_Y, COMPUTER_1_NAME),
             Board.new(SIZE_X, SIZE_Y, COMPUTER_2_NAME)]

    board[0].generate(*SHIPS_COUNT)
    board[1].generate(*SHIPS_COUNT)

    player_name = [COMPUTER_1_NAME, COMPUTER_2_NAME]

    current_player = 0
    result = ' '
    auto = :OFF
    delay = 1
    loop do
      if auto == :OFF
        display(*board)
        puts "Turn: #{player_name[current_player]}\n"
        puts "Press:Enter to continue\tQ+Enter - exit\tA+Enter - demo mode"
        inp = gets.chop
        case inp
        when 'Q', 'q' then return
        when 'A', 'a' then auto = :ON
        when 'AF', 'af'
          auto = :ON
          delay = 0.2
        end
      end

      hit = loop do
        hit = [rand(SIZE_X), rand(SIZE_Y)]
        result = board[current_player - 1].shoot(*hit)
        break hit if result != 'ALREADY SHOT'
      end

      display(*board)
      puts "Turn: #{player_name[current_player]}"
      puts "Hit: #{@alphabet[hit[0]]}#{hit[1]} - #{result}"

      case result
      when 'MISSED'
        current_player == 0 ? (current_player = 1) : (current_player = 0)
      when 'INJURED'
        sleep(delay)
        next
      when 'KILLED'
        if board[current_player - 1].is_ship_alive? == false
          congratulation player_name[current_player]
          return
        end
        sleep(delay)
      end
      sleep(delay)
    end
  end

  def congratulation(name)
    puts "\nCONGRATULATION!!!"
    puts "#{name} has won"
    puts 'GAME OVER'
    sleep(2)
  end

  def human_vs_human
    puts "\nUnder construction. Try later..."
  end

  def human_vs_comp
    puts "\nUnder construction. Try later..."
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
