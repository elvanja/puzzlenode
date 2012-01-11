require_relative 'chess_moves_validator'

raise ArgumentError, "Couldn't fine board file" unless ARGV[0] && File.exist?(ARGV[0])
board = File.open(ARGV[0])

raise ArgumentError, "Couldn't fine moves file" unless ARGV[1] && File.exist?(ARGV[1])
moves = File.open(ARGV[1])

puts ChessMoveValidator.validate(board, moves)
