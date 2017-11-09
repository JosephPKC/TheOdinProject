
class Board

  def initialize
    @board = initialize_board
    @w_check = false
    @b_check = false
    @w_king = Pos.new(7, 4)
    @b_king = Pos.new(0, 4)
  end

  def to_s
    (1..8).each { |i| print "#{i}" }
    print '\n'
    8.times do |r|
      print "#{r}" + @board[r].join(' ') + '\n'
    end
  end

  # Tests whether this move is valid
  def check_move(src, dst, team)
    # Check whether src and dst are in the board.
    return false unless in_board?(src) && in_board?(dst)
    # Check whether src is a piece that you are allowed to move
    return false if empty?(src) || !enemy?(pos, team)
    # Check whether src == dest
    return false if src == dst
    # Check if the king will be under check given this move
    return false if checks_king?(src, dst, team)
    # Get all naive moves, trim out the invalid ones, and check if dst is in the list
    trim_moves(at(src).moves).include? dst
  end

  def move(t = nil, src, dst)
    if at(src).type == :king
      update_king(dst, at(src).team)
    end

    attack = !at(dst).nil?
    type = attack ? at(dst).type : nil
    @board[dst.row][dst.col] = @board[src.row][src.col]
    @board[src.row][src.col] = nil

    if t == :en_passant
      if at(dst).team == :white
        @board[dst.row + 1][dst.col] = nil
      else
        @board[dst.row - 1][dst.col] = nil
      end
      type = :pawn
      attack = true
    elsif t == :castle
      row = at(dst).team == :white ? 7 : 0
      if dir(src, dst) == [0, 1]
        @board[row][dst.col - 1] = @board[row][7]
        @board[row][7] = nil
      elsif dir(src, dst) == [0, -1]
        @board[row][dst.col + 1] = @board[row][0]
        @board[row][0] = nil
      end
      type = nil
      attack = false
    end
    return attack, type
  end

  def update_king(new_pos, team)
    if team == :white
      @w_king = new_pos
    else
      @b_king = new_pos
    end
  end

  # Check and set the check flag for the team
  def set_check(team)
    if team == :white
      @w_check = true if checks_king?(team)
    else
      @b_check = true if checks_king?(team)
    end
  end

  def unset_check(team)
    if team == :white
      @w_check = false
    else
      @b_check = false
    end
  end

  # Checks whether the game is over or not, given the player who just went
  def check_mate(team)
    # If the team's king is under check, and the team has no valid moves -> Check mate
    # If the team's king is not under check, and the team has no valid moves -> Stale mate
    moves = valid_moves(team)
    if team == :white
      if @w_check && moves.empty?
        return true, :check_mate
      elsif !@w_check && moves.empty?
        return true, :stale_mate
      else
        return false, nil
      end
    else
      if @b_check && moves.empty?
        return true, :check_mate
      elsif !@b_check && moves.empty?
        return true, :stale_mate
      else
        return false, nil
      end
    end
  end

  # Promotes the piece
  def promote(pos, team)
    # If the piece at pos is the team's pawn, and it is at the opposing end
    # Prompt user for a new piece. Destroy the pawn and create a new piece of type whatever the user chose
    # Place that piece at the pawn location.
    return false unless at(pos).type == :pawn
    return false unless at(pos).team == team
    return false unless pos.row == (team == :white ? 0 : 7)
    ready = false
    print 'Which piece to promote pawn to? (K, R, B, Q)\n'
    until ready
      piece = gets.chomp.downcase
      case piece
        when 'k'
          replace_with(pos, :knight, team)
          ready = true
        when 'r'
          replace_with(pos, :rook, team)
          ready = true
        when 'b'
          replace_with(pos, :bishop, team)
          ready = true
        when 'q'
          replace_with(pos, :queen, team)
          ready = true
        else
          print 'Pick one of K, R, B, Q\n'
      end
    end
    true
  end

  private

  def at(pos)
    @board[pos.row][pos.col] if in_board?(pos)
  end

  def in_board?(pos)
    pos.row >= 0 && pos.row < 8 && pos.col >= 0 && pos.col < 8
  end

  def empty?(pos)
    at(pos).nil?
  end

  def enemy?(pos, team)
    at(pos).team == team unless at(pos).nil?
  end

  def blocked?(src, dst)
    # Get the in-between pieces of src and dst
    # Determine which direction this move is in
    r, c = direction(src, dst)
    current = Pos.new(src.row + r, src.col + c)
    until current == dst
      return true unless at(current).empty?
      current = Pos.new(current.row + r, current.col + c)
    end
    false
  end

  def attacking?(src, dst)
    !empty(dst) && enemy?(dst, at(src).team)
  end

  def checks_king?(src = nil, dst = nil, team)
    # If src and dst are not nil, then keep those positions in mind
    # From the team's king, check each of the 8 directions for the very first piece.
    # Ignore the piece at src, and place a temporary friendly piece at dst
    # For every enemy piece that has direct line of sight
    # Check if that piece can attack the king (straights - rook/queen, diagonals - bishop/queen, diagonal adjacent - pawn)
    # If there is AT LEAST ONE enemy that satisfies these things, the king is checked.
    if team == :white
      lines_of_sight = get_line_of_sight(@w_king, src, dst)
      lines_of_sight.each do |p|
        next if p.team == :white
        return true if check_if_can_attack(p, @w_king)
      end
    else
      lines_of_sight = get_line_of_sight(@b_king, src, dst)
      lines_of_sight.each do |p|
        next if p.team == :black
        return true if check_if_can_attack(p, @b_king)
      end
    end
    false
  end

  def direction(src, dst)
    if src.row == dst.row
      if src.col > dst.col
        return 0, -1
      elsif src.col < dst.col
        return 0, 1
      else
        return 0, 0 # They are at the same loc.
      end
    elsif src.col == dst.col
      if src.row > dst.row
        return -1, 0
      elsif src.row < dst.row
        return 1, 0
      end
    elsif src.row - dst.row == 1
      if src.col - dst.col == 1
        return -1, -1
      elsif src.col - dst.col == -1
        return -1, 1
      end
    elsif src.row - dst.row == -1
      if src.col - dst.col == 1
        return 1, -1
      elsif src.col - dst.col == -1
        return 1, 1
      end
    end
    return 0, 0
  end

  def trim_moves(moves)
    moves_array = []
    moves.each_pair do |type, move|
      moves_array << move[1] if verify_move(type, move)
    end
    moves_array
  end

  def verify_move(type, move)
    # Case out the move types:
    # Jump - 4 step L
    #   - 1 in any direction, and 3 in any direction in the other direction;
    #   - Can jump over pieces
    # Move - Move following the movement patterns;
    #   - Cannot be blocked
    #   - Does not have to be an attack
    # Move Only
    #   - Cannot be blocked
    #   - Cannot be an attack
    # Attack Only
    #   - Cannot be blocked
    #   - Must be an attack
    # Double Move
    #   - Cannot be blocked
    #   - Can move twice your movement pattern
    #   - Must be your initial move
    #   - Must be a pawn
    # En Passant
    #   - Cannot be blocked
    #   - Special attack (the target has to be in front of the attacker at the end)
    #   - Can only target enemy pawns that have just double moved adjacent to you
    #   - Must be a pawn
    # Castle - Moves the king two spaces towards a rook, and the rook moves to the other side of the king
    #   - Must be a king
    #   - King must not have moved previously
    #   - The rook must not have moved previously
    #   - The paths cannot be blocked (except for the king and the rook)
    #   - The king cannot be under check
    #   - The king's path cannot be under check
    #   - The king's destination cannot be under check
    #   - The king and the rook cannot be attacking
    return false unless in_board?(move[1])
    case type
    when :move_only
      return false if blocked?(move[0], move[1])
      return false unless empty?(move[1])
      return true
    when :attack_only
      return false if blocked?(move[0], move[1])
      return false unless attacking?(move[0], move[1])
      return true
    when :move
      return false if blocked?(move[0], move[1])
      return false unless empty?(move[1]) || attacking?(move[0], move[1])
      return true
    when :double_move
      return false if blocked?(move[0], move[1])
      return false unless at(move[0]).type == :pawn
      return false if at(move[0]).moved
      return true
    when :en_passant
      return false if blocked?(move[0], move[1])
      return false unless empty?(move[1])
      return false unless en_passant(src, dst)
      return true
    when :jump
      return false unless empty?(move[1]) || attacking?(move[0], move[1])
      return true
    when :castle
      return false if blocked?(move[0], move[1])
      return false unless castle(src, dst)
      return true
    else
      return false
    end
    false
  end

  def valid_moves(team)
    moves = []
    @board.each do |r|
      r.each do |p|
        moves << trim_moves(p.moves) unless p.nil? || p.team != team
      end
    end
    moves
  end

  def replace_with(pos, type, team)
    case type
    when :knight
      @board[pos.row][pos.col] = Knight.new(pos, team)
    when :rook
      @board[pos.row][pos.col] = Rook.new(pos, team)
    when :bishop
      @board[pos.row][pos.col] = Bishop.new(pos, team)
    when :queen
      @board[pos.row][pos.col] = Queen.new(pos, team)
    end
  end

  def get_line_of_sight(pos, src, dst)
    los = []

    # North
    piece = get_first_piece(pos, src, dst, -1, 0)
    los << piece unless piece.nil?

    # South
    piece = get_first_piece(pos, src, dst, 1, 0)
    los << piece unless piece.nil?

    # East
    piece = get_first_piece(pos, src, dst, 0, 1)
    los << piece unless piece.nil?

    # West
    piece = get_first_piece(pos, src, dst, 0, -1)
    los << piece unless piece.nil?

    # Northeast
    piece = get_first_piece(pos, src, dst, -1, 1)
    los << piece unless piece.nil?

    # Northwest
    piece = get_first_piece(pos, src, dst, -1, -1)
    los << piece unless piece.nil?

    # Southeast
    piece = get_first_piece(pos, src, dst, 1, 1)
    los << piece unless piece.nil?

    # Southwest
    piece = get_first_piece(pos, src, dst, 1, -1)
    los << piece unless piece.nil?

    los
  end

  def get_first_piece(pos, src, dst, i, j)
    while pos.row + i >= 0 && pos.row + i <= 7 && \
          pos.col + j >= 0 && pos.col + j <= 7
      current_pos = Pos.new(pos.row + i, pos.col + j)
      return at(dst) if current_pos == dst
      return at(current_pos) unless at(current_pos).nil? || \
                                         current_pos == src
      i += 1 unless i.zero?
      j += 1 unless j.zero?
    end
    nil
  end

  def check_if_can_attack(pos, dst)
    if pos.row == dst.row || pos.col == dst.col
      return at(pos).type == :queen || at(pos).type == :rook
    elsif (pos.row - dst.row).abs == (pos.col - dst.col).abs
      if at(pos).team == :white
        return true if at(pos).type == :pawn && pos.row - dst.row == 1
      else
        return true if at(pos).type == :pawn && dst.row - row.row == 1
      end
      return at(pos).type == :queen || at(pos).type == :bishop
    elsif (pos.row - dst.row).abs == 3 && (pos.col - dst.col).abs == 1 || \
          (pos.row - dst.row).abs == 1 && (pos.col - dst.col).abs == 3
      return at(pos).type == :knight
    elsif (pos.row - dst.row).abs <= 1 && (pos.col - dst.col).abs <= 1
      return at(pos).type == :king
    end
    false
  end

  def en_passant(src, dst)
    if at(src).team == :white
      pawn = at(Pos.new(dst.row + 1, dst.col))
      return false unless pawn.type == :pawn && pawn.team != :white && pawn.double_moved
    else
      pawn = at(Pos.new(dst.row - 1, dst.col))
      return false unless pawn.type == :pawn && pawn.team != :black && pawn.double_moved
    end
    true
  end

  def castle(src, dst)
  # Castle - Moves the king two spaces towards a rook, and the rook moves to the other side of the king
  #   - Must be a king
  #   - King must not have moved previously
  #   - The rook must not have moved previously
  #   - The paths cannot be blocked (except for the king and the rook)
  #   - The king cannot be under check
  #   - The king's path cannot be under check
  #   - The king's destination cannot be under check
  #   - The king and the rook cannot be attacking
    piece = at(src)
    row = piece.team == :white ? 7 : 0

    dir = direction(src, dst)
    if dir == [0, 1] # Kingside castle
      rook = at(Pos.new(row, 7))
    elsif dir == [0, -1] #Queenside castle
      rook = at(Pos.new(row, 0))
    else # Error
      return false
    end

    rook_dst = Pos.new(row, src.col + (dir == [0, 1] ? -1 : 1))

    return false unless piece.type == :king
    return false if piece.moved
    return false if rook.empty? || rook.type != :rook
    return false if rook.moved
    return false if blocked?(src, dst) || blocked?(rook.pos, rook_dst)
    return false if piece.team == :white ? @w_check : @b_check
    return false if path_under_attack(src, dst)
    return false if attacking?(src, dst) || attacking?(rook.pos, rook_dst)
    true
  end

  def path_under_attack(src, dst)
    dir = direction(src, dst)
    until src.row == dst.row && src.col == dst.col
      # return true if src
    end
  end

  def initialize_board
    board = []
    # Create an 8x8 array
    8.times do
      board << [nil, nil, nil, nil, nil, nil, nil, nil]
    end
    # Create pawns for both sides
    create_pawns(board, :white)
    create_pawns(board, :black)
    # Create specials
    create_back_line(board, :white)
    create_back_line(board, :black)
    board
  end

  def create_pawns(board, team)
    row = team == :white ? 6 : 1
    (0..7).times do |i|
      board[row][i] = Pawn.new(Pos.new(row, i), team == :white)
    end
  end

  def create_back_line(board, team)
    row = team == :white ? 7 : 0
    board[row][0] = Rook.new(Pos.new(row, 0), team == :white)
    board[row][7] = Rook.new(Pos.new(row, 7), team == :white)
    board[row][1] = Knight.new(Pos.new(row, 1), team == :white)
    board[row][6] = Knight.new(Pos.new(row, 6), team == :white)
    board[row][2] = Bishop.new(Pos.new(row, 2), team == :white)
    board[row][5] = Bishop.new(Pos.new(row, 5), team == :white)
    board[row][3] = Queen.new(Pos.new(row, 3), team == :white)
    board[row][4] = King.new(Pos.new(row, 4), team == :white)
  end
end