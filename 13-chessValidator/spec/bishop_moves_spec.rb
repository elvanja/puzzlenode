require_relative '../chess_moves_validator'

describe 'bishop moves for chess validator:' do
  before(:each) do
    @board = ChessMoveValidator::Board.new
    @board.e1 = 'wK'
    @board.e8 = 'bK'
  end

  it "can't move horizontally or vertically" do
    @board.d4 = 'wB'
    @board.d4_b4?.should == false
    @board.d4_g4?.should == false
    @board.d4_d6?.should == false
    @board.d4_d2?.should == false
  end

  it 'moves diagonally' do
    @board.d5 = 'bB'
    @board.d5_b7?.should == true
    @board.d5_a2?.should == true
    @board.d5_g8?.should == true
    @board.d5_f3?.should == true
  end

  it "can't jump over figures" do
    @board.d5 = 'wB'
    @board.b3 = 'wP'
    @board.b7 = 'bP'
    @board.e6 = 'wN'
    @board.f3 = 'bB'
    @board.d5_a2?.should == false
    @board.d5_a8?.should == false
    @board.d5_f7?.should == false
    @board.d5_h1?.should == false
  end

  describe 'white bishop' do
    it "can't move to occupied field" do
      @board.d5 = 'wB'
      @board.e6 = 'wP'
      @board.d5_e6?.should == false
    end

    it "eats black" do
      @board.d5 = 'wB'
      @board.f3 = 'bP'
      @board.d5_f3?.should == true
    end

    it "can't move to a field that doesn't protect the king" do
      @board.a1 = 'bQ'
      @board.d3 = 'wB'
      @board.d3_e2?.should == false
    end

    it "can't move from a field that protects the king" do
      @board.a1 = 'bQ'
      @board.d1 = 'wB'
      @board.d1_c2?.should == false
   end

    it "can move to a field that protects the king" do
      @board.a1 = 'bQ'
      @board.d3 = 'wB'
      @board.d3_b1?.should == true
    end
  end

  describe 'black bishop' do
    it "can't move to occupied field" do
      @board.d5 = 'bB'
      @board.e6 = 'bP'
      @board.d5_e6?.should == false
    end

    it "eats white" do
      @board.d5 = 'bB'
      @board.f3 = 'wP'
      @board.d5_f3?.should == true
    end

    it "can't move to a field that doesn't protect the king" do
      @board.a8 = 'wQ'
      @board.e6 = 'bB'
      @board.e6_d7?.should == false
    end

    it "can't move from a field that protects the king" do
      @board.a8 = 'wQ'
      @board.d8 = 'bB'
      @board.d8_e7?.should == false
    end

    it "can move to a field that protects the king" do
      @board.a8 = 'wQ'
      @board.e6 = 'bB'
      @board.e6_c8?.should == true
    end
  end
end
