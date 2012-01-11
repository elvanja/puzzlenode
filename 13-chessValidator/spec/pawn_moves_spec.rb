require_relative '../chess_moves_validator'

describe 'pawn moves for chess validator:' do
  before(:each) do
    @board = ChessMoveValidator::Board.new
    @board.e1 = 'wK'
    @board.e8 = 'bK'
  end

  describe 'white pawn' do
    it "can't move backwards" do
      @board.d4 = 'wP'
      @board.d4_d3?.should == false
      @board.d4_c3?.should == false
      @board.d4_e3?.should == false
    end

    it 'can advance one field' do
      @board.a2 = 'wP'
      @board.a2_a3?.should == true
    end

    it 'can advance two fields from base row if no figures on path' do
      @board.a2 = 'wP'
      @board.a2_a4?.should == true
    end

    it "can't advance two fields from base row if there are figures on path" do
      @board.a2 = 'bP'
      @board.a3 = 'bP'
      @board.e2_a4?.should == false
    end

    it "can't advance two fields from another row" do
      @board.a3 = 'bP'
      @board.a3_a5?.should == false
    end

    it "can't advance to occupied field" do
      @board.a2 = 'wP'
      @board.a3 = 'wP'
      @board.a2_a3?.should == false
    end

    it 'eats black' do
      @board.a2 = 'wP'
      @board.b3 = 'bP'
      @board.a2_b3?.should == true
    end

    it "can't eat on empty field" do
      @board.a2 = 'wP'
      @board.a2_b3?.should == false
    end

    it "can't eat same color" do
      @board.a2 = 'wP'
      @board.b3 = 'wP'
      @board.a2_b3?.should == false
    end

    it 'eats black on left' do
      @board.d5 = 'wP'
      @board.c6 = 'bP'
      @board.d5_c6?.should == true
    end

    it 'eats black on right' do
      @board.d5 = 'wP'
      @board.e6 = 'bP'
      @board.d5_e6?.should == true
    end

    it "can't eat on empty field" do
      @board.d5 = 'wP'
      @board.d5_c6?.should == false
    end

    it "can't eat same oclor" do
      @board.d5 = 'wP'
      @board.c6 = 'wP'
      @board.d5_c6?.should == false
    end

    it "can't move to a field that doesn't protect the king" do
      @board.a1 = 'bQ'
      @board.d2 = 'wP'
      @board.d2_d3?.should == false
    end

    it "can't move from a field that protects the king" do
      @board.e1 = nil
      @board.e2 = 'wK'
      @board.a2 = 'bQ'
      @board.d2 = 'wP'
      @board.d2_d3?.should == false
    end

    it "can move to a field that protects the king" do
      @board.e1 = nil
      @board.e3 = 'wK'
      @board.a3 = 'bQ'
      @board.d2 = 'wP'
      @board.d2_d3?.should == true
    end
  end

  describe 'black pawn' do
    it "can't move backwards" do
      @board.d4 = 'bP'
      @board.d4_d5?.should == false
      @board.d4_c5?.should == false
      @board.d4_e5?.should == false
    end

    it 'can advance one field' do
      @board.d7 = 'bP'
      @board.d7_d6?.should == true
    end

    it 'can advance two fields from base row if no figures on path' do
      @board.d7 = 'bP'
      @board.d7_d5?.should == true
    end

    it "can't advance two fields from base row if there are figures on path" do
      @board.d7 = 'bP'
      @board.d6 = 'bP'
      @board.d7_d5?.should == false
    end

    it "can't advance two fields from another row" do
      @board.d6 = 'bP'
      @board.d6_d4?.should == false
    end

    it "can't advance to occupied field" do
      @board.d7 = 'bP'
      @board.d6 = 'wP'
      @board.d7_d6?.should == false
    end

    it 'eats white on left' do
      @board.d5 = 'bP'
      @board.c4 = 'wP'
      @board.d5_c4?.should == true
    end

    it 'eats white on right' do
      @board.d7 = 'bP'
      @board.e6 = 'wP'
      @board.d7_e6?.should == true
    end

    it "can't eat on empty field" do
      @board.d7 = 'bP'
      @board.d7_e6?.should == false
    end

    it "can't eat same color" do
      @board.d7 = 'bP'
      @board.e6 = 'bP'
      @board.d7_e6?.should == false
    end

    it "can't move to a field that doesn't protect the king" do
      @board.a8 = 'wQ'
      @board.d7 = 'bP'
      @board.d7_d6?.should == false
    end

    it "can't move from a field that protects the king" do
      @board.e8 = nil
      @board.e7 = 'bK'
      @board.a7 = 'wQ'
      @board.d7 = 'bP'
      @board.d7_d6?.should == false
    end

    it "can move to a field that protects the king" do
      @board.e8 = nil
      @board.e6 = 'bK'
      @board.a6 = 'wQ'
      @board.d7 = 'bP'
      @board.d7_d6?.should == true
    end
  end
end
