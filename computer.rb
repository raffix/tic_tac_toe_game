class Computer
  def initialize(symbol, level)
    @symbol = symbol
    @level = level
    @opponent_symbol = symbol == 'X' ? 'O' : 'X'
  end

  def get_movement(board)
    puts 'get_movement'
    position = 0
    case @level
    when 'easy'
      position = get_bad_move(board)
    when 'normal'
      position = get_normal_move(board)
    when 'hard'
      position = get_best_move(board)
    end
    position 
  end

  private

  def get_bad_move(board)
    board.each_with_index do |position, index|
      return index if position != 'X' && position != 'O'
    end
  end

  def get_normal_move(board)
    random_move(board)
  end

  def get_best_move(board)
    winning_move = find_winning_move(board, @symbol)
    return winning_move if winning_move

    blocking_move = find_winning_move(board, @opponent_symbol)
    return blocking_move if blocking_move

    center_position = 4
    return center_position if board[center_position] == '-'

    corner_positions = [0, 2, 6, 8]
    empty_corners = get_empty_positions(board) & corner_positions
    return empty_corners.sample if !empty_corners.empty?

    edge_positions = [1, 3, 5, 7]
    empty_edges = get_empty_positions(board) & edge_positions
    return empty_edges.sample if !empty_edges.empty?

    random_move(board)
  end

  def random_move(board)
    empty_positions = get_empty_positions(board)
    empty_positions.sample
  end

  def get_empty_positions(board)
    empty_positions = []
    board.each_with_index do |cell, index|
      empty_positions << index if position_empty(cell)
    end
    empty_positions
  end

  def find_winning_move(board, player_symbol)
    Game::WINNING_COMBINATIONS.each do |combination|
      filled_count = 0
      empty_position = nil

      combination.each do |position|
        if board[position] == player_symbol
          filled_count += 1
        elsif position_empty(board[position])
          empty_position = position
        end
      end

      return empty_position if filled_count == 2 && empty_position
    end

    nil
  end

  def position_empty(value)
    value != 'X' && value != 'O'
  end
end