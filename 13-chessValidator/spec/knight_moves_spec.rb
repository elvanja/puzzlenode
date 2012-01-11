require_relative '../chess_moves_validator'

describe 'knight moves for chess validator:' do
  before(:each) do
    @board = ChessMoveValidator::Board.new
    @board.e1 = 'wK'
    @board.e8 = 'bK'
  end

  it "can't move diagonally or vertically or horizontally" do
    @board.d4 = 'wN'
    @board.d4_c5?.should == false
    @board.d4_e5?.should == false
    @board.d4_c3?.should == false
    @board.d4_e3?.should == false
    @board.d4_b4?.should == false
    @board.d4_f4?.should == false
    @board.d4_d6?.should == false
    @board.d4_d2?.should == false
  end

  it "moves like a knight" do
    @board.d4 = 'wN'
    @board.d4_b5?.should == true
    @board.d4_b3?.should == true
    @board.d4_c6?.should == true
    @board.d4_c2?.should == true
    @board.d4_e6?.should == true
    @board.d4_e2?.should == true
    @board.d4_f5?.should == true
    @board.d4_f3?.should == true
  end

  describe 'white knight' do
    it "can't move to a field that doesn't protect the king" do
      @board.a1 = 'bQ'
      @board.d3 = 'wN'
      @board.d3_b2?.should == false
    end

    it "can't move from a field that protects the king" do
      @board.a1 = 'bQ'
      @board.d1 = 'wN'
      @board.d1_e3?.should == false
    end

    it "can move to a field that protects the king" do
      @board.a1 = 'bQ'
      @board.d3 = 'wN'
      @board.d3_c1?.should == true
    end
  end

  describe 'black knight' do
    it "can't move to a field that doesn't protect the king" do
      @board.a8 = 'wQ'
      @board.e6 = 'bN'
      @board.e6_c7?.should == false
    end

    it "can't move from a field that protects the king" do
      @board.a8 = 'wQ'
      @board.d8 = 'bN'
      @board.d8_e6?.should == false
    end

    it "can move to a field that protects the king" do
      @board.a8 = 'wQ'
      @board.e6 = 'bN'
      @board.e6_d8?.should == true
    end
  end
end
