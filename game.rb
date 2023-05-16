require_relative 'computer'

class Game
  WINNING_COMBINATIONS = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],  # Rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8],  # Columns
    [0, 4, 8], [2, 4, 6]              # Diagonals
  ]

  LEVELS = ['easy', 'normal', 'hard']
  def initialize
    @level = 'easy'
    @board = ['0', '1', '2', '3', '4', '5', '6', '7', '8']
    @player1 = 'X'
    @player2 = 'O'
    @current_player = 'X'
    @computer = nil
  end

  def select_level
    print "\e[2J\e[f"
    puts "Welcome to TIC TAC TOE game, please select a level of difficult:\n1 - Easy (selected)\n2 - Normal\n3 - Hard\n"
    level = gets.chomp.to_i
    if level < 1 && level > 3
      select_level
    end
    @level = LEVELS[level-1]
    @computer = Computer.new('X', @level)

    start_game
  end

  def start_game
    print_board
    until game_is_over(@board) || tie(@board)
      position = @current_player == 'X' ? @computer.get_movement(@board) : get_human_spot
      @board[position] = @current_player
      switch_players
      print_board
    end
    puts 'Game over'
  end

  def print_board
    print "\e[2J\e[f"
    puts "#{@board[0]} | #{@board[1]} | #{@board[2]}" 
    puts "===+===+===" 
    puts "#{@board[3]} | #{@board[4]} | #{@board[5]}"
    puts "===+===+==="
    puts "#{@board[6]} | #{@board[7]} | #{@board[8]}"
    puts "Enter with your move[0 - 8]:"
  end

  def get_human_spot
    spot = nil
    until spot
      spot = gets.chomp
      return spot.to_i if valid_input(spot) && empty_position(spot.to_i) && valid_spot(spot.to_i)
      puts "#{spot} is invalid, please try again.\nEnter with your move [0 - 8]:"
      spot = nil
    end
  end

  def eval_board
    spot = nil
    until spot
      if @board[4] == '4'
        spot = 4
        @board[spot] = @com
      else
        spot = get_computer_movement
        if empty_position(spot)
          @board[spot] = @com
        else
          spot = nil
        end
      end
    end
  end
  
  def game_is_over(b)
    winner('X') || winner('O')
  end

  def winner(symbol)
    WINNING_COMBINATIONS.any? do |combination|
      combination.all? { |index| @board[index] == symbol }
    end
  end

  def switch_players
    @current_player = (@current_player == @player1) ? @player2 : @player1
  end

  def tie(b)
    b.all? { |s| s == 'X' || s == 'O' }
  end

  def empty_position(index)
    @board[index] != 'x' && @board[index] != 'O'
  end

  def valid_spot(spot)
    spot >= 0 && spot <=8
  end

  def valid_input(spot)
    number = spot.to_i
    number.to_s == spot
  end
end

game = Game.new
game.select_level


