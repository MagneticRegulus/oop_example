# OO Rock, Paper, Scissors

class RPSGame
  WIN_SCORE = 10

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

  def display_moves
    # system clear
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      human.win
    elsif human.move < computer.move
      computer.win
    else
      puts "It's a tie!"
    end
  end

  def display_scores
    puts "#{human.name}: #{human.score} pts."
    puts "#{computer.name}: #{computer.score} pts."
  end

  def champion?
    human.score >= WIN_SCORE || computer.score >= WIN_SCORE
  end

  def display_champion
    puts "Must have 10 points to win!" unless champion?
    if champion?
      champ = (human.score >= WIN_SCORE ? human : computer)
      puts "#{champ.name} is the champion!"
    end
  end

  def play_again?
    answer = nil

    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp
      break if %w[y n].include?(answer.downcase)
      puts 'Invalid answer. Please choose y or n.'
    end

    answer.downcase == 'y'
  end

  def play
    display_welcome_message

    loop do
      loop do
        human.choose
        computer.choose
        display_moves
        display_winner
        display_scores
        display_champion
        break if champion?
      end
      break unless play_again?
    end

    display_goodbye_message
  end
end

class Player
  attr_accessor :move, :name
  attr_reader :score

  def initialize
    set_name
    @score = 0
  end

  def win
    @score += 1
    puts "#{name} won!"
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
    self.name = %w[R2D2 Hal Chappie Sonny Number5].sample
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
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
  end

  def to_s
    @move
  end
end

RPSGame.new.play
