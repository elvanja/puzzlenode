require_relative '../chess_moves_validator'

describe 'rook moves for chess validator:' do
  before(:each) do
    @board = ChessMoveValidator::Board.new
    @board.e1 = 'wK'
    @board.e8 = 'bK'
  end

  it "can't move diagonally" do
    @board.d4 = 'wR'
    @board.d4_c5?.should == false
    @board.d4_e5?.should == false
    @board.d4_c3?.should == false
    @board.d4_e3?.should == false
  end

  it "can't move like a knight" do
    @board.d4 = 'bR'
    @board.d4_b5?.should == false
    @board.d4_b3?.should == false
    @board.d4_c6?.should == false
    @board.d4_c2?.should == false
    @board.d4_e6?.should == false
    @board.d4_e2?.should == false
    @board.d4_f5?.should == false
    @board.d4_f3?.should == false
  end

  it "can move vertically or horizontally" do
    @board.d4 = 'wR'
    @board.d4_b4?.should == true
    @board.d4_f4?.should == true
    @board.d4_d6?.should == true
    @board.d4_d2?.should == true
  end

  it "can't jump over figures" do
    @board.d5 = 'bR'
    @board.d7 = 'bP'
    @board.d4 = 'wN'
    @board.b5 = 'bB'
    @board.f5 = 'wR'
    @board.d5_d8?.should == false
    @board.d5_d1?.should == false
    @board.d5_a5?.should == false
    @board.d5_h5?.should == false
  end

  describe 'white rook' do
    it "can't move to occupied field" do
      @board.d5 = 'wR'
      @board.a5 = 'wP'
      @board.d5_a5?.should == false
    end

    it "eats black" do
      @board.d5 = 'wR'
      @board.a5 = 'bP'
      @board.d5_a5?.should == true
    end

    it "can't move to a field that doesn't protect the king" do
      @board.a1 = 'bQ'
      @board.d2 = 'wR'
      @board.d2_e2?.should == false
    end

    it "can't move from a field that protects the king" do
      @board.a1 = 'bQ'
      @board.d1 = 'wR'
      @board.d1_d2?.should == false
    end

    it "can move to a field that protects the king" do
      @board.a1 = 'bQ'
      @board.d2 = 'wR'
      @board.d2_d1?.should == true
    end
  end

  describe 'black rook' do
    it "can't move to occupied field" do
      @board.d5 = 'bR'
      @board.a5 = 'bP'
      @board.d5_a5?.should == false
    end

    it "eats white" do
      @board.d5 = 'bR'
      @board.a5 = 'wP'
      @board.d5_a5?.should == true
    end

    it "can't move to a field that doesn't protect the king" do
      @board.a8 = 'wQ'
      @board.d7 = 'bR'
      @board.d7_e7?.should == false
    end

    it "can't move from a field that protects the king" do
      @board.a8 = 'wQ'
      @board.d8 = 'bR'
      @board.d8_d7?.should == false
    end

    it "can move to a field that protects the king" do
      @board.a8 = 'wQ'
      @board.d7 = 'bR'
      @board.d7_d8?.should == true
    end
  end
end
