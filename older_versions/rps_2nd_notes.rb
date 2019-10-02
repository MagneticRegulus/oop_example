# OO Rock, Paper, Scissors

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Player.new
    @computer = Player.new(:computer)
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

    case human.move
    when 'rock'
      puts "It's a tie!" if computer.move == 'rock'
      puts "#{human.name} won!" if computer.move == 'scissors'
      puts "#{computer.name} won!" if computer.move == 'paper'
    when 'paper'
      puts "It's a tie!" if computer.move == 'paper'
      puts "#{human.name} won!" if computer.move == 'rock'
      puts "#{computer.name} won!" if computer.move == 'scissors'
    when 'scissors'
      puts "It's a tie!" if computer.move == 'scissors'
      puts "#{human.name} won!" if computer.move == 'paper'
      puts "#{computer.name} won!" if computer.move == 'rock'
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
  CHOICES = ['rock', 'paper', 'scissors']

  attr_accessor :move, :name

  def initialize(player_type = :human)
    @player_type = player_type
    @move = nil
    set_name
  end

  def set_name
    if human?
      answer = nil

      loop do
        puts "What's your name?"
        answer = gets.chomp
        break unless answer.empty?
        puts 'Sorry, you must enter a name.'
      end

      self.name = answer
    else
      self.name = %w(R2D2 Hal Chappie Sonny Number5).sample
    end
  end

  def choose
    if human?
      choice = nil
      loop do
        puts 'Please choose rock, paper, or scissors:'
        choice = gets.chomp
        break if CHOICES.include?(choice)
        puts 'Invalid choice.'
      end
      self.move = choice
    else
      self.move = CHOICES.sample
    end
  end

  def human?
    @player_type == :human
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
