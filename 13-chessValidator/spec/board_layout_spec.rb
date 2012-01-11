require_relative '../chess_moves_validator'

describe 'board layout for chess validator:' do
  describe 'board' do
    before(:each) do
      @board = ChessMoveValidator::Board.new
    end

    it 'places figures on the board' do
      lambda{ @board.a1 = 'wR' }.should_not raise_error
    end

    it 'respects allowed figure positions' do
      lambda{ @board.c1 = 'wP' }.should raise_error ArgumentError, "White pawn can't be placed in first row"
      lambda{ @board.c1 = 'bP' }.should_not raise_error
      lambda{ @board.d8 = 'bP' }.should raise_error ArgumentError, "Black pawn can't be placed at last row"
      lambda{ @board.d8 = 'wP' }.should_not raise_error
    end

    it 'retrieves placed figures' do
      @board.a1 = 'wR'
      @board.a1.should == 'wR'
      @board.a2.should == nil
    end

    it 'fails placing figure if the field is occupied' do
      @board.h4 = 'bP'
      lambda{ @board.h4 = 'wP' }.should raise_error ArgumentError, "Field h4 already taken by bP"
      @board.h4.should == 'bP'
    end

    it 'fails placing invalid types of figures' do
      lambda{ @board.a1 = ' ' }.should raise_error ArgumentError, "Figure can't be empty"
      lambda{ @board.a1 = 'red' }.should raise_error ArgumentError, "Figure 'red' is not a valid figure"
      lambda{ @board.a1 = 'rP' }.should raise_error ArgumentError, "Figure 'rP' should be black or white"
      lambda{ @board.a1 = 'wZ' }.should raise_error ArgumentError, "Type not recognized for figure 'wZ'"
      @board.a1.should == nil
    end

    it 'removes figure from the board' do
      @board.a2 = 'wP'
      @board.a2.should == 'wP'
      lambda{ @board.a2 = nil }.should_not raise_error
      @board.a2.should == nil
    end
  end
end
