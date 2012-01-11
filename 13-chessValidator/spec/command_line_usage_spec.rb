require_relative '../chess_moves_validator'

describe 'chess validator command line usage' do
  it "parses sample board" do
    board = StringIO.new
    board.puts "bR bN bB bQ bK bB bN bR"
    board.puts "bP bP bP bP bP bP bP bP"
    board.puts "-- -- -- -- -- -- -- --"
    board.puts "-- -- -- -- -- -- -- --"
    board.puts "-- -- -- -- -- -- -- --"
    board.puts "-- -- -- -- -- -- -- --"
    board.puts "wP wP wP wP wP wP wP wP"
    board.puts "wR wN wB wQ wK wB wN wR"
    board.rewind

    moves = StringIO.new
    moves.puts "a2 a3"
    moves.puts "a2 a4"
    moves.puts "a2 a5"
    moves.puts "a7 a6"
    moves.puts "a7 a5"
    moves.puts "a7 a4"
    moves.puts "a7 b6"
    moves.puts "b8 a6"
    moves.puts "b8 c6"
    moves.puts "b8 d7"
    moves.puts "e2 e3"
    moves.puts "e3 e2"
    moves.rewind

    expected = [:LEGAL, :LEGAL, :ILLEGAL, :LEGAL, :LEGAL, :ILLEGAL, :ILLEGAL, :LEGAL, :LEGAL, :ILLEGAL, :LEGAL, :ILLEGAL].join("\n")

    ChessMoveValidator.validate(board, moves).should == expected
  end
end
