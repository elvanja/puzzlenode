module ChessMoveValidator
  class Figure
    attr_reader :color, :type

    def initialize(descriptor)
      descriptor ||= ""
      descriptor.strip!
      raise ArgumentError, "Figure can't be empty" if descriptor.empty?
      raise ArgumentError, "Figure '#{descriptor}' is not a valid figure" if descriptor.size != 2
      raise ArgumentError, "Figure '#{descriptor}' should be black or white" unless %w{ b w }.include?(descriptor[0].downcase)
      raise ArgumentError, "Type not recognized for figure '#{descriptor}'" unless %w{ P R N B Q K }.include?(descriptor[1].upcase)

      types = [ :pawn, :rook, :knight, :bishop, :queen, :king ]
      colors = [ :white, :black ]

      @figure = descriptor[0].downcase + descriptor[1].upcase
      @color = colors.select{ |color| color[0] == @figure[0] }.first
      @type = types.select{ |type| type != :knight && type[0].upcase == @figure[1] }.first
      @type = :knight if @figure[1] == "N"
    end

    def to_s
      @figure
    end

    def opponent_color
      @color == :white ? :black : :white
    end
  end

  class Board
    attr_reader :layout, :columns, :rows, :black_king, :white_king

    def initialize(*args)
      @layout = args[0] || {}
      @columns = ('a'..'h').to_a
      @rows = (1..8).to_a
      @black_king = args[1] || nil
      @white_king = args[2] || nil

      unless self.respond_to?("#{@columns.first}#{@rows.first}")
        @columns.each do |column|
          @rows.each do |row|
            position = "#{column}#{row}"

            # set initially empty field
            @layout[position] = nil

            # returns content of the field on board, determined from method name
            # e.g. Board.new.h3 or Board.new.d5
            self.class.send(:define_method, position) { @layout[position].to_s if @layout[position] }

            # places a figure on the board, position determined from method name
            # e.g. Board.new.h3 = 'bP'
            self.class.send(:define_method, "#{position}=") do |figure|
              unless figure
                old_figure = @layout[position]
                if old_figure
                  @white_king = nil if old_figure.type == :king && old_figure.color == :white
                  @black_king = nil if old_figure.type == :king && old_figure.color == :black
                end
                @layout[position] = nil
                return
              end

              figure = Figure.new(figure)
              raise ArgumentError, "Field #{position} already taken by #{@layout[position]}" if @layout[position]
              raise ArgumentError, "White pawn can't be placed in first row" if position[1].to_i == @rows.first && figure.color == :white && figure.type == :pawn
              raise ArgumentError, "Black pawn can't be placed at last row" if position[1].to_i == @rows.last && figure.color == :black && figure.type == :pawn
              if figure.type == :king && figure.color == :black
                raise ArgumentError, "Black king has already been placed on the board" if @black_king
                @black_king = figure
              end
              if figure.type == :king && figure.color == :white
                raise ArgumentError, "White king has already been placed on the board" if @white_king && @white_king != figure
                @white_king = figure
              end
              @layout[position] = figure
            end
          end
        end
      end
    end

    def clone
      Board.new(@layout.clone, @black_king, @white_king)
    end

    def to_s
      board = ""
      @rows.reverse.each do |row|
        board += "\n" unless board.empty?
        @columns.each do |column|
          figure = @layout["#{column}#{row}"]
          board += (figure ? "#{figure.to_s} " : "-- ")
        end
      end
      board
    end

    def move(from, to)
      raise ArgumentError, "Move #{from} => #{to} is not valid" unless move_valid?(from, to)
      @layout[to] = @layout[from]
      @layout[from] = nil
    end

    def move_valid?(from, to)
      figure = @layout[from]
      return false unless figure

      # can't play without the kings
      return false unless @black_king && @white_king

      # based on figure type and current position
      # gather the possible fields to land the figure on
      # see if the desired field is in the gathered list
      possible = get_possible_moves_for_figure(from)
      return false unless possible.include?(to)

      # will my move expose my king?
      # will my move defend my king?
      # it make no sense to test for check condition of the opponent king?
      # (if I am on the move and the opponent king is in check, that is not a valid situation)
      board = self.clone
      board.send("#{from}=", nil)
      board.send("#{to}=", nil) # eats if the field is not empty, empty it before because of figure placing validation
      board.send("#{to}=", figure.to_s)
      !board.is_check?(figure.color)
    end

    def get_guarded_fields_for_figure(position)
      figure = @layout[position]
      return self.send("get_guarded_fields_for_#{figure.type.to_s}".to_sym, position)
    end

    def get_possible_moves_for_figure(position)
      figure = @layout[position]
      return self.send("get_possible_moves_for_#{figure.type.to_s}".to_sym, position)
    end

    def get_guarded_fields_for_pawn(from)
      get_moves_for_pawn(from, true)
    end

    def get_possible_moves_for_pawn(from)
      get_moves_for_pawn(from, false)
    end

    def get_moves_for_pawn(from, guarding)
      moves = []
      pawn = @layout[from]
      direction = (pawn.color == :white ? 1 : -1)
      color = (guarding ? pawn.color : pawn.opponent_color)

      unless guarding
        advance_one = get_relative_position(from, 0, direction)
        if advance_one && !@layout[advance_one]
          moves << advance_one
          if from[1] == @rows.first(2).last.to_s && pawn.color == :white or from[1] == @rows.last(2).first.to_s && pawn.color == :black
            advance_two = get_relative_position(from, 0, direction * 2)
            moves << advance_two if advance_two && !@layout[advance_two]
          end
        end
      end

      left = get_relative_position(from, -1, direction)
      moves << left if left && !@layout[left] && guarding
      moves << left if left && @layout[left] && @layout[left].color == color

      right = get_relative_position(from, 1, direction)
      moves << right if right && !@layout[right] && guarding
      moves << right if right && @layout[right] && @layout[right].color == color

      moves
    end

    def get_guarded_fields_for_knight(from)
      get_moves_for_knight(from, true)
    end

    def get_possible_moves_for_knight(from)
      get_moves_for_knight(from, false)
    end

    def get_moves_for_knight(from, guarding)
      moves = []
      knight = @layout[from]
      [{cols: -2, rows: -1}, {cols: -2, rows: 1}, {cols: -1, rows: -2}, {cols: -1, rows: 2},
       {cols: 2, rows: -1}, {cols: 2, rows: 1}, {cols: 1, rows: -2}, {cols: 1, rows: 2}].each do |direction|
        position = get_relative_position(from, direction[:cols], direction[:rows])
        moves << position if position && !@layout[position]
        moves << position if position && @layout[position] && (guarding || @layout[position].color != knight.color)
      end
      moves
    end

    def get_guarded_fields_for_bishop(from)
      get_moves_for_bishop(from, true)
    end

    def get_possible_moves_for_bishop(from)
      get_moves_for_bishop(from, false)
    end

    def get_moves_for_bishop(from, guarding)
      moves = []
      bishop = @layout[from]
      [{cols: -1, rows: -1}, {cols: -1, rows: 1}, {cols: 1, rows: -1}, {cols: 1, rows: 1}].each do |direction|
        position = from
        while position = get_relative_position(position, direction[:cols], direction[:rows]) do
          break if @layout[position]
          moves << position
        end
        moves << position if position && @layout[position] && (guarding || @layout[position].color != bishop.color)
      end
      moves
    end

    def get_guarded_fields_for_rook(from)
      get_moves_for_rook(from, true)
   end

    def get_possible_moves_for_rook(from)
      get_moves_for_rook(from, false)
    end

    def get_moves_for_rook(from, guarding)
      moves = []
      rook = @layout[from]
      [{cols: -1, rows: 0}, {cols: 1, rows: 0}, {cols: 0, rows: -1}, {cols: 0, rows: 1}].each do |direction|
        position = from
        while position = get_relative_position(position, direction[:cols], direction[:rows]) do
          break if @layout[position]
          moves << position
        end
        moves << position if position && @layout[position] && (guarding || @layout[position].color != rook.color)
      end
      moves
    end

    def get_guarded_fields_for_queen(from)
      get_moves_for_queen(from, true)
    end

    def get_possible_moves_for_queen(from)
      get_moves_for_queen(from, false)
    end

    def get_moves_for_queen(from, guarding)
      moves = []
      queen = @layout[from]
      [{cols: -1, rows: -1}, {cols: -1, rows: 1}, {cols: 1, rows: -1}, {cols: 1, rows: 1},
       {cols: -1, rows: 0}, {cols: 1, rows: 0}, {cols: 0, rows: -1}, {cols: 0, rows: 1}].each do |direction|
        position = from
        while position = get_relative_position(position, direction[:cols], direction[:rows]) do
          break if @layout[position]
          moves << position
        end
        moves << position if position && @layout[position] && (guarding || @layout[position].color != queen.color)
      end
      moves
    end

    def get_guarded_fields_for_king(from)
      get_moves_for_king(from, true)
    end

    def get_possible_moves_for_king(from)
      get_moves_for_king(from, false)
    end

    def get_moves_for_king(from, guarding)
      moves = []
      king = @layout[from]
      [{cols: -1, rows: -1}, {cols: -1, rows: 0}, {cols: -1, rows: 1}, {cols: 0, rows: -1},
       {cols: 0, rows: 1}, {cols: 1, rows: -1}, {cols: 1, rows: 0}, {cols: 1, rows: 1}].each do |direction|
        position = get_relative_position(from, direction[:cols], direction[:rows])

        next unless position
        moves << position and next if guarding

        position_is_guarded = position_is_guarded?(position, king.color)
        # can't move to empty field if the field is on some of the opponent's figures path
        moves << position if !@layout[position] && !position_is_guarded
        # can't eat if of the same color or is protected by another figure
        moves << position if @layout[position] && @layout[position].color != king.color && !position_is_guarded
      end
      moves
    end

    def get_relative_position(position, delta_columns, delta_rows)
      return if (column = @columns.index(position[0]) + delta_columns) < 0 || column > @columns.size - 1
      return if (row = @rows.index(position[1].to_i) + delta_rows) < 0 || row > @rows.size - 1
      relative_position = "#{@columns[column]}#{@rows[row]}"
      relative_position if self.respond_to?(relative_position.to_sym)
    end

    def position_is_guarded?(position, color)
      @columns.each do |column|
        @rows.each do |row|
          opponent_position = "#{column}#{row}"
          opponent = @layout[opponent_position]
          return true if opponent && opponent.color != color && get_guarded_fields_for_figure(opponent_position).include?(position)
        end
      end
      false
    end

    def is_check?(color)
      king = (color == :white ? @white_king : @black_king)
      king_position = get_figure_position(king)
      @columns.each do |column|
        @rows.each do |row|
          opponent = @layout["#{column}#{row}"]
          next unless opponent && opponent.color != color
          return true if position_is_guarded?(king_position, king.color)
        end
      end
      false
    end

    def get_figure_position(figure)
      @columns.each do |column|
        @rows.each do |row|
          position = "#{column}#{row}"
          f = @layout["#{column}#{row}"]
          return position if figure == f
        end
      end
    end

    def method_missing(method, *args, &block)
      from, to = is_move_valid_method?(method)
      return self.move_valid?(from, to) if from && to
      super(method, args, block)
    end

    def respond_to_missing?(method, *)
      is_move_valid_method?(method) || super
    end

    def is_move_valid_method?(method)
      if method.to_s =~ /(.*)_(.*)\?/
        return $1, $2 if self.respond_to?($1) && self.respond_to?($2)
      end
    end
  end

  def self.validate(board_data, moves_data)
    board = Board.new
    row = board.rows.last

    raise ArgumentError, "Can't work without board data" unless board_data
    raise ArgumentError, "Board data must be readable" unless board_data.respond_to?(:gets)
    while line = board_data.gets
      raise ArgumentError, "There is more rows in board data than can be accepted" if row < board.rows.first
      fields = line.split(" ")
      fields.each_index do |i|
        raise ArgumentError, "Can't have a column on position #{i+1}" if i > board.columns.size - 1
        board.send("#{board.columns[i]}#{row}=", fields[i]) unless fields[i] == '--'
      end
      row -= 1
    end

    raise ArgumentError, "Can't work without moves data" unless moves_data
    raise ArgumentError, "Moves data must be readable" unless moves_data.respond_to?(:gets)
    results = []
    while move = moves_data.gets
      valid = board.send("#{move.strip.tr(' ', '_')}?")
      results << (valid ? :LEGAL : :ILLEGAL)
    end
    results.join("\n")
  end
end
