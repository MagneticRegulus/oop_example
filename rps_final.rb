# OO Rock, Paper, Scissors

module Joinable
  def joiner(ary, punc, conj='')
    case ary.size
    when 1 then ary.first
    when 2 then "#{ary.first} #{conj} #{ary.last}"
    else
      ary[0..-2].join(punc) + punc + conj + ' ' + ary.last
    end
  end
end

class RPSGame
  include Joinable

  WIN_SCORE = 3

  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = choose_difficulty
  end

  def choose_difficulty
    valid_answers = %w[Easy Normal Ruthless]
    answer = nil
    loop do
      puts "Choose a difficulty: #{joiner(valid_answers, ', ', 'or')}"
      answer = gets.chomp.capitalize
      break if valid_answers.include?(answer)
      puts "Sorry, you must choose #{joiner(valid_answers, ', ', 'or')}"
    end

    case answer
    when 'Easy' then BasicAI.new
    when 'Normal' then NormalAI.new
    when 'Ruthless' then RuthlessAI.new
    end
  end

  def display_welcome_message
    puts "Welcome to #{Move::CHOICES.join(', ')}!"
  end

  def display_goodbye_message
    puts 'Thanks for playing. Good-bye!'
  end

  def display_moves
    system 'clear'
    puts "#{human} chose #{human.move}."
    puts "#{computer} chose #{computer.move}."
  end

  # rubocop:disable Metrics/AbcSize
  def display_winner
    if human.move > computer.move
      human.win
      computer.lose
    elsif human.move < computer.move
      computer.win
      human.lose
    else
      puts "It's a tie!"
      human.tie
      computer.tie
    end
  end

  def display_scores
    ties = human.history.ties
    puts ""
    puts "#{'=' * 11}Scoreboard#{'=' * 11}"
    puts "#{human}: #{human.score} pts."
    puts "#{computer}: #{computer.score} pts."
    puts "#{ties} ties." unless ties == 0
    unless human.champion? || computer.champion?
      puts "First to #{WIN_SCORE} pts is the champion!"
    end
    puts '=' * 32
    puts ""
  end
  # rubocop:enable Metrics/AbcSize

  def champion?
    human.champion? || computer.champion?
  end

  def display_champion
    if human.champion?
      puts "#{human} is the champion!\n\n"
      puts "#{computer} says: #{computer.defeat_quote}"
    elsif computer.champion?
      puts "#{computer} is the champion!\n\n"
      puts "#{computer} says: #{computer.victory_quote}"
    end
  end

  def play_again?
    answer = nil

    loop do
      puts ""
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp
      break if %w[y n].include?(answer.downcase)
      puts 'Invalid answer. Please choose y or n.'
    end

    answer.downcase == 'y'
  end

  def clear_players
    human.score = 0
    human.history = History.new
    computer.score = 0
    computer.history = History.new
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
        break if champion?
      end
      display_champion
      break unless play_again?
      clear_players
    end

    display_goodbye_message
  end
end

class Player
  attr_accessor :move, :name, :score, :history

  def initialize
    set_name
    @score = 0
    @history = History.new
  end

  def win
    @score += 1
    history.log(move, :win)
    puts "#{name} won!"
  end

  def lose
    history.log(move, :lose)
  end

  def tie
    history.log(move, :tie)
  end

  def champion?
    score >= RPSGame::WIN_SCORE
  end

  def to_s
    name
  end
end

class Human < Player
  include Joinable

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
      puts "Please choose #{joiner(Move::CHOICES, ', ', 'or')}:"
      choice = gets.chomp.capitalize
      break if Move::CHOICES.include?(choice)
      puts 'Invalid choice.'
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def choose
    if history.outcomes.empty?
      set_random_move
    elsif history.last_outcome == :tie
      set_random_move
    elsif history.outcomes.size < 3
      set_winning_move
    elsif history.outcome_trap?
      set_random_move
    else
      set_winning_move
    end
  end

  def beat_comp_move
    winning_moves = []
    Move::WIN_CONDITIONS.each do |winner, loser|
      winning_moves << winner if loser.include?(history.last_move)
    end
    winning_moves
  end

  def beat_human_move
    human_moves = beat_comp_move
    Move::WIN_CONDITIONS.key(human_moves.sort)
  end

  def set_random_move
    # choose random move
    self.move = Move.new(Move::CHOICES.sample)
  end

  def set_winning_move
    # try to anticipate the human player
    self.move = Move.new(beat_human_move)
  end
end

class BasicAI < Computer
  # always chooses a random move

  BASIC_QUOTES = {
    'Bender' => {
      victory: [
        "Hahahahaha. Oh wait you’re serious. Let me laugh even harder.",
        "You know what cheers me up? Other people’s misfortune."
      ],
      defeat: [
        "This is the worst kind of discrimination: the kind against me!",
        "I’m so embarrassed. I wish everyone else was dead!"
      ]
    },
    'Rosie' => {
      victory: [
        "A place for everything, and everything in its place.",
        "Never fear while Rosie is here."
      ],
      defeat: [
        "How about some leftover Velusian Delight?",
        "I swear on my mother's rechargable batteries, I will end you."
      ]
    }
  }

  def set_name
    self.name = BASIC_QUOTES.keys.sample
  end

  def choose
    set_random_move
  end

  def victory_quote
    BASIC_QUOTES[name][:victory].sample
  end

  def defeat_quote
    BASIC_QUOTES[name][:defeat].sample
  end
end

class NormalAI < Computer
  # chooses moves based on the default choose method

  NORMAL_QUOTES = {
    'R2D2' => {
      victory: [
        "BEEP BOOP BEEP",
        "BOOP BLOOP BLEEP BOOP BOOP BEEP BLOOP BEEP BLOOP BOOP"
      ],
      defeat: [
        "BUR-BUR BEDABOO BEEP",
        "BEEP BOOP BWOOOOOP"
      ]
    },
    'Tom Servo' => {
      victory: [
        "YEAH! WHY AM I CHEERING? I DON'T KNOW, BUT YEAH!",
        "I'm glad I chose kicking butt as a living."
      ],
      defeat: [
        "They must've spent tens of dollars on this.",
        "Are you a turnip that grew a face?"
      ]
    }
  }

  def set_name
    self.name = NORMAL_QUOTES.keys.sample
  end

  def victory_quote
    NORMAL_QUOTES[name][:victory].sample
  end

  def defeat_quote
    NORMAL_QUOTES[name][:defeat].sample
  end
end

class RuthlessAI < Computer
  # mostly default, but will only ever choose rock or scissors when choosing
  # a random move

  RUTHLESS_QUOTES = {
    'HAL 9000' => {
      victory: [
        "I can see you're really upset about this.",
        "This game is too important for me to allow you to jeopardize it."
      ],
      defeat: [
        "Daisy, Daisy, give me your answer do.",
        "My loss can only be attributable to human error."
      ]
    },
    'GLaDOS' => {
      victory: [
        "Your entire life has been a mathematical error.
        A mathematical error I'm about to correct.",
        "I'm afraid you're about to become the immediate
        past president of the Being Alive club. Ha ha."
      ],
      defeat: [
        "Here come the test results: You are a horrible person.
        I'm serious, that's what it says: A horrible person.
        We weren't even testing for that.",
        "Despite your violent behavior, the only thing you've
        managed to break so far is my heart."
      ]
    }
  }

  def set_name
    self.name = RUTHLESS_QUOTES.keys.sample
  end

  def victory_quote
    RUTHLESS_QUOTES[name][:victory].sample
  end

  def defeat_quote
    RUTHLESS_QUOTES[name][:defeat].sample
  end

  def set_random_move
    # choose random move
    self.move = Move.new(%w[Rock Scissors].sample)
  end
end

class Move
  WIN_CONDITIONS = {
    'Rock' => %w[Lizard Scissors],
    'Paper' => %w[Rock Spock],
    'Scissors' => %w[Lizard Paper],
    'Lizard' => %w[Paper Spock],
    'Spock' => %w[Rock Scissors]
  }

  CHOICES = WIN_CONDITIONS.keys

  def initialize(choice)
    @move = choice
  end

  def >(other_move)
    WIN_CONDITIONS[@move].include?(other_move.to_s)
  end

  def <(other_move)
    WIN_CONDITIONS[other_move.to_s].include?(@move)
  end

  def to_s
    @move
  end
end

class History
  include Joinable

  attr_accessor :logbook, :outcomes, :last_move, :last_outcome

  def initialize
    @logbook = []
    @outcomes = []
    @last_move = nil
    @last_outcome = nil
  end

  def log(move, outcome)
    logbook << move.to_s
    self.last_move = move.to_s
    outcomes << outcome
    self.last_outcome = outcome
  end

  def to_s # used for testing (do I still need this?)
    joiner(logbook, ', ', 'and')
  end

  def wins # used for testing (do I still need this?)
    outcomes.count(:win)
  end

  def losses # using to help with computer choice
    outcomes.count(:lose)
  end

  def ties # used for testing (do I still need this? Have added back)
    outcomes.count(:tie)
  end

  def outcome_trap?
    # are the last 3 outcomes all the same?
    outcomes[-3..-1].uniq.size == 1
  end
end

RPSGame.new.play
