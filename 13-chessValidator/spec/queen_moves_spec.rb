require_relative '../chess_moves_validator'

describe 'queen moves for chess validator:' do
  before(:each) do
    @board = ChessMoveValidator::Board.new
    @board.e1 = 'wK'
    @board.e8 = 'bK'
  end

  it "can move diagonally or vertically or horizontally" do
    @board.d4 = 'wQ'
    @board.d4_c5?.should == true
    @board.d4_e5?.should == true
    @board.d4_c3?.should == true
    @board.d4_e3?.should == true
    @board.d4_b4?.should == true
    @board.d4_f4?.should == true
    @board.d4_d6?.should == true
    @board.d4_d2?.should == true
  end

  it "can't move like a knight" do
    @board.d4 = 'bQ'
    @board.d4_b5?.should == false
    @board.d4_b3?.should == false
    @board.d4_c6?.should == false
    @board.d4_c2?.should == false
    @board.d4_e6?.should == false
    @board.d4_e2?.should == false
    @board.d4_f5?.should == false
    @board.d4_f3?.should == false
  end

  it "can't jump over figures" do
    @board.d5 = 'wQ'
    @board.d7 = 'bP'
    @board.d4 = 'wN'
    @board.b5 = 'bB'
    @board.f5 = 'wR'
    @board.b3 = 'wP'
    @board.b7 = 'bP'
    @board.e6 = 'wN'
    @board.f3 = 'bB'
    @board.d5_d8?.should == false
    @board.d5_d1?.should == false
    @board.d5_a5?.should == false
    @board.d5_h5?.should == false
    @board.d5_a2?.should == false
    @board.d5_a8?.should == false
    @board.d5_f7?.should == false
    @board.d5_h1?.should == false
   end

  describe 'white queen' do
    it "can't move to a field that doesn't protect the king" do
      @board.a1 = 'bR'
      @board.d2 = 'wQ'
      @board.d2_e2?.should == false
    end

    it "can't move from a field that protects the king" do
      @board.a1 = 'bR'
      @board.d1 = 'wQ'
      @board.d1_d2?.should == false
    end

    it "can move to a field that protects the king" do
      @board.a1 = 'bR'
      @board.d2 = 'wQ'
      @board.d2_c1?.should == true
    end
  end

  describe 'black' do
    it "can't move to a field that doesn't protect the king" do
      @board.a8 = 'wR'
      @board.d7 = 'bQ'
      @board.d7_e7?.should == false
    end

    it "can't move from a field that protects the king" do
      @board.a8 = 'wR'
      @board.d8 = 'bQ'
      @board.d8_c7?.should == false
    end

    it "can move to a field that protects the king" do
      @board.a8 = 'wR'
      @board.d7 = 'bQ'
      @board.d7_c8?.should == true
    end
  end
end
