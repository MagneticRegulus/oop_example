# OO Rock, Paper, Scissors

class RPSGame
  def initialize
    # what goes here?
  end

  def play
=begin
    What methods are required to play the game? (should these be private?)
    - display_welcome_message
    - human_choose_move (redundant?)
    - computer_choose_move (redundant?)
    - display_winner
    - display_goodbye_message
=end
  end
end

class Player
  def initialize
    # a name and define a move?
  end

  def choose
    # choose a move
  end
end

class Move
  def initialize
    # keep track (of move?)
    # only 3 available options for a move object
  end
end

class Rule
  def initialize
    # what should the state of this object be?
  end
end

def compare(move1, move2)
  # where does this go?
end

RPSGame.new.play
