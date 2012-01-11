Six Degrees of Separation
====================

_written by Vanja Radovanović_

Proposed solution to the related [puzzle](http://puzzlenode.com/puzzles/23) from [Puzzle Node](http://puzzlenode.com)

Usage
---------------------

From Command line run:

    ruby present.rb [file with messages] > [file with results]

e.g.

    ruby present.rb sample/complex_input.txt > results/complex_output.txt


Solution to the puzzle
---------------------

can be found in results/complex_output.txt

Notes
---------------------

Solution is located in social_network.rb and is consisted of the following components:

- MentionsExtractor
  - receives a message in the following format: "simon: some text with a number of mentions denoted like this: @brian, @anna, that need not be at the end"
  - returns the author and and array of mentions extracted from the message content
- FirstOrderConnectionsExtractor
  - receives author with mentions
  - extracts unique first order connections, e.g. removes unidirectional mentions between authors
- ConnectionsPresenter
  - takes first order connections and formats them according to the requirement in the puzzle
All components have their respective tests in spec folder.

Additional runner is located in present.rb, for which the usage is explained above.
