require_relative '../chess_moves_validator'

describe 'king moves for chess validator:' do
  before(:each) do
    @board = ChessMoveValidator::Board.new
  end

  describe 'white king' do
    before(:each) do
      @board.e8 = 'bK'
    end

    it "can't move to field guarded by black pawn" do
      @board.d4 = 'wK'
      @board.c6 = 'bP'
      @board.d4_d5?.should == false
    end

    it "can't move to field guarded by black rook" do
      @board.d4 = 'wK'
      @board.a5 = 'bR'
      @board.d4_d5?.should == false
    end

    it "can't move to field guarded by black bishop" do
      @board.d4 = 'wK'
      @board.c6 = 'bB'
      @board.d4_d5?.should == false
    end

     it "can't move to field guarded by black knight" do
      @board.d4 = 'wK'
      @board.c7 = 'bN'
      @board.d4_d5?.should == false
    end

    it "can't move to field guarded by black queen" do
      @board.d4 = 'wK'
      @board.b3 = 'bQ'
      @board.d4_d5?.should == false
    end

    it "can't move to field guarded by black king" do
      @board.e6 = 'wK'
      @board.e6_e7?.should == false
    end

    it "can't eat guarded black figure" do
      @board.d4 = 'wK'
      @board.a5 = 'bR'
      @board.c5 = 'bP'
      @board.d4_c5?.should == false
    end

    it "can't eat white figure" do
      @board.d4 = 'wK'
      @board.c5 = 'wP'
      @board.d4_c5?.should == false
    end

    it "can move from check to a field that protects the king" do
      @board.e1 = 'wK'
      @board.a1 = 'bR'
      @board.b2 = 'bQ'
      @board.d2 = 'wP'
      @board.e1_e2?.should == true
    end
  end

  describe 'black king' do
    before(:each) do
      @board.e1 = 'wK'
    end

    it "can't move to field guarded by black pawn" do
      @board.d6 = 'bK'
      @board.e4 = 'wP'
      @board.d6_d5?.should == false
    end

    it "can't move to field guarded by white rook" do
      @board.d6 = 'bK'
      @board.a5 = 'wR'
      @board.d6_d5?.should == false
    end

    it "can't move to field guarded by white bishop" do
      @board.d6 = 'bK'
      @board.c4 = 'wB'
      @board.d6_d5?.should == false
    end

     it "can't move to field guarded by white knight" do
      @board.d6 = 'bK'
      @board.c3 = 'wN'
      @board.d6_d5?.should == false
    end

    it "can't move to field guarded by white queen" do
      @board.d6 = 'bK'
      @board.b3 = 'wQ'
      @board.d6_d5?.should == false
    end

    it "can't move to field guarded by white king" do
      @board.e3 = 'bK'
      @board.e3_e2?.should == false
    end

    it "can't eat guarded white figure" do
      @board.d6 = 'bK'
      @board.a5 = 'wR'
      @board.c5 = 'wP'
      @board.d6_c5?.should == false
    end

    it "can't eat black figure" do
      @board.d6 = 'bK'
      @board.c5 = 'bP'
      @board.d6_c5?.should == false
    end

    it "can move from check to a field that protects the king" do
      @board.e8 = 'bK'
      @board.a8 = 'wR'
      @board.b7 = 'wQ'
      @board.d7 = 'bP'
      @board.e8_e7?.should == true
    end
  end
end
