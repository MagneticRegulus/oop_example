# OO Rock, Paper, Scissors

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts 'Welcome to Rock, Paper, Scissors!'
  end

  def display_goodbye_message
    puts 'Thanks for playing. Good-bye!'
  end

  def display_winner
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."

    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil

    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp
      break if %w(y n).include?(answer.downcase)
      puts 'Invalid answer. Please choose y or n.'
    end

    answer == 'y'
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      display_winner
      break unless play_again?
    end

    display_goodbye_message
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
  end

end

class Human < Player
  def set_name
    answer = nil
    loop do
      puts "What's your name?"
      answer = gets.chomp
      break unless answer.empty?
      puts 'Sorry, you must enter a name.'
    end
    self.name = answer
  end

  def choose
    choice = nil
    loop do
      puts 'Please choose rock, paper, or scissors:'
      choice = gets.chomp
      break if Move::CHOICES.include?(choice)
      puts 'Invalid choice.'
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = %w(R2D2 Hal Chappie Sonny Number5).sample
  end

  def choose
    self.move = Move.new(Move::CHOICES.sample)
  end
end

class Move
  CHOICES = ['rock', 'paper', 'scissors']

  def initialize(choice)
    @move = choice
  end

  def rock?
    @move == 'rock'
  end

  def paper?
    @move == 'paper'
  end

  def scissors?
    @move == 'scissors'
  end

  def >(other_move)
    if rock?
      return true if other_move.scissors?
      return false
    elsif paper?
      return true if other_move.rock?
      return false
    elsif scissors?
      return true if other_move.paper?
      return false
    end
  end

  def <(other_move)
    if rock?
      return true if other_move.paper?
      return false
    elsif paper?
      return true if other_move.scissors?
      return false
    elsif scissors?
      return true if other_move.rock?
      return false
    end
  end

  def to_s
    @move
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
