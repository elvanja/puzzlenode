Chess Moves Validator
=====================

_written by Vanja Radovanović_

Proposed solution to the related [puzzle](http://puzzlenode.com/puzzles/22) from [Puzzle Node](http://puzzlenode.com)

Usage
---------------------

From Command line run:

    ruby validate.rb [board layout file] [moves list file] > [file with results]

e.g.

    ruby validate.rb sample/complex_board.txt sample/complex_moves.txt > results/complex_results.txt


Solution to the puzzle
---------------------

can be found in results/complex_results.txt

Notes
---------------------

Solution is located in chess_moves_validator.rb and is consisted of the following components:
- Board
  - describes the chess board with figures on it
  - when initializing it creates methods for placing figures on the board and getting the content of a field, like this:
    ```ruby
    board = Board.new
    board.a2 = 'wP'
    board.a2 == 'wP' asserts true
    board.b2 == nil asserts true
    board.a2 == 'bP' asserts false
    ```
  - method_missing and respond_to_missing? are used to allow for move validation inquiries like this:
    ```ruby
    board = Board.new
    board.e1 = 'wK'
    board.e8 = 'bK'
    board.a2 = 'wP'
    board.a2_a3? asserts true
    ```
- Figure
  - a placeholder for figures
  - used to enable separate figure validation from board responsibilities
  - and to make a nicer representation of a figure (e.g. _figure.color == :white_ instead of _figure[0] == 'w'_)

Specs are divided by the responsibility, e.g. board layout and figure placing is separated from king movement validations.

Additional runner is located in validate.rb, for which the usage is explained above.
