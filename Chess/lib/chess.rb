# Implement board methods
# Implement recorder
# Implement keeper
# Implement pieces
# Do Rspecs


class Chess

  def initialize
    @exit = false
    @turn = :white
    @board = Board.new
    @w_check = false
    @b_check = false
    @recorder = Recorder.new
    @keeper = Keeper.new
  end

  # Primary game-play loop
  def run
    while true
      play = false
      until play
        input = menu_input
        play = process_menu_input(input)
      end
      loop if play
    end
  end

  private

  def loop
    until @exit
      # Re-create the display
      display
      # Get user input
      input = user_input
      # Process user input (Perform commands, check move validity, perform move)
      process_input(input)
    end
  end

  def menu_input
    system 'cls'
    print 'new : Begin a new game.\n'
    print 'load [x] : Load a game from save [x].\n'
    print 'exit : Exit.\n'
    gets.chomp.downcase
  end

  def process_menu_input(input)
    inputs = input.split
    case input[0]
    when 'new'
      return true
    when 'load'
      @keeper.load(inputs[1])
    when 'exit'
      exit(0)
    else
      error(:unknown_command, [input])
    end
    false
  end

  def display
    system 'cls'
    print "#{@turn}'s turn\n"
    print @board + '\n'
  end

  def user_input
    print '> '
    gets.chomp.downcase
  end

  def process_input(input)
    inputs = input.split
    case inputs
    when 'exit'
      @exit = true
    when 'move'
      if @board.check_move(inputs[1], inputs[2], @turn)
        # move the piece
        atk, piece = @board.move(inputs[1], inputs[2])
        # promote piece if applicable
        @board.promote(inputs[1], @turn)
        # set check for the opposing player if applicable/remove check flag if applicable
        @board.unset_check(@turn)
        @board.set_check(@turn == :white ? :black : :white)
        # check for checkmate or stalemate
        mate, type = @board.check_mate(@turn == :white ? :black : :white)
        # record the move, any check, and any mate
        @recorder.record_move(inputs[1], inputs[2],
                              @turn == :white ? @b_check : @w_check,
                              mate, type)
        # end the game if checkmate or stalemate
        end_game(type) if mate
        # change turns
        @turn = @turn == :white ? :black : :white
      else
        # Invalid move. Input another move or command
        error(:invalid_move, [inputs[1], inputs[2]])
      end
    when 'save'
      # Save the board, the turn, and the record history
      @keeper.save(@board, @turn, @recorder)
    when 'load'
      # Exit the current game and Load a game given a file
      @keeper.load(inputs[1])
    else
      error(:unknown_command, [input])
    end
  end

  def end_game(type)
    if type == :check_mate
      print "Checkmate! #{@turn} is the winner!\n"
    else
      print "Stalemate!\n"
    end
    print 'Press any key to continue.'
    gets
    @exit = true
  end

  def error(code, vals)
    case code
    when :unknown_command
      print "Unknown command: #{vals[0]}\n"
    when :invalid_move
      print "Invalid move: #{vals[0]} to #{vals[1]}\n"
    else
      print "Invalid code: #{code}\n"
    end
  end

end