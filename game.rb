require_relative 'computer'

class Game
  WINNING_COMBINATIONS = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],  # Rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8],  # Columns
    [0, 4, 8], [2, 4, 6]              # Diagonals
  ]

  LEVELS = ['easy', 'normal', 'hard']
  GAME_TYPES = ['computers', 'computer_human', 'humans']
  def initialize
    @level = 'easy'
    @board = ['0', '1', '2', '3', '4', '5', '6', '7', '8']
    @player1 = 'X'
    @player2 = 'O'
    @current_player = 'X'
    @computer1 = nil
    @computer2 = nil
    @game_type = 'computer_human'
  end

  def run
    select_kind
  end

  private

  def select_kind
    print "\e[2J\e[f"
    puts "Welcome to TIC TAC TOE game, select the kind of game\n1 - Computer vs Computer\n2 - Computer vs Human\n3 - Human vs Human"
    type = gets.chomp.to_i
    if type < 1 && type > 3
      select_kind
    end

    @game_type = GAME_TYPES[type-1]

    if @game_type == GAME_TYPES[0]
      @computer1 = Computer.new('X', LEVELS[2])
      @computer2 = Computer.new('O', LEVELS[2])
    end
    
    return select_level if @game_type == GAME_TYPES[1]
    
    start_game
  end

  def select_level
    puts "Please select a level of difficult:\n1 - Easy\n2 - Normal\n3 - Hard\n"
    level = gets.chomp.to_i
    if level < 1 && level > 3
      select_level
    end
    @level = LEVELS[level-1]
    @computer1 = Computer.new('X', @level)

    start_game
  end

  def start_game
    print_board
    until game_is_over(@board) || tie(@board)
      position = get_position
      @board[position] = @current_player
      switch_players
      print_board
    end
    puts 'Game over'
  end

  def get_position
    position = ''
    case @game_type
    when GAME_TYPES[0]
      position = @current_player == 'X' ? @computer1.get_movement(@board) : @computer2.get_movement(@board)
    when GAME_TYPES[1]
      position = @current_player == 'X' ? @computer1.get_movement(@board) : get_human_spot
    when GAME_TYPES[2]
      position = get_human_spot
    end

    position
  end

  def print_board
    print "\e[2J\e[f"
    puts "#{@current_player == @player1 ? 'Player 1' : 'Player 2'} turn"
    puts "#{@board[0]} | #{@board[1]} | #{@board[2]}" 
    puts "===+===+===" 
    puts "#{@board[3]} | #{@board[4]} | #{@board[5]}"
    puts "===+===+==="
    puts "#{@board[6]} | #{@board[7]} | #{@board[8]}"
    puts "Enter with your move, select the spot number[0 - 8]:" if @game_type != GAME_TYPES[0]
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
game.run
