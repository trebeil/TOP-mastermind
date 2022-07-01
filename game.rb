class Game
  attr_accessor :guesses, :model, :pins, :round, :rounds

  def initialize
    @guesses = []
    @pins = []
    @round = 1
  end

  def define_rounds
    puts
    puts 'How many rounds do you want the game to have?'
    self.rounds = gets.chomp.to_i
    while self.rounds <= 0
      puts
      puts 'Please input number of rounds greater than 0:'
      self.rounds = gets.chomp.to_i
    end
  end

  def randomize_model_colors
    puts
    puts 'Ok, now the computer will select the colors!'
    puts 'Selecting colors...'
    sleep 1
    puts '.'
    sleep 1
    puts '.'
    sleep 1
    puts '.'
    sleep 1
    self.model = Array.new(3)
    model = self.model
    (0..3).each do |i|
      model[i] = Random.new.rand(40..47)
      model[i] = Random.new.rand(40..47) until model.one?(model[i])
    end
    puts 'Great, colors chosen! Let\'s start!'
    sleep 1
  end

  def choose_colors
    puts '_________________________________________________________________'
    puts "Round #{round} of #{rounds}"
    puts
    puts 'Choose a sequence of 4 colors among the options below. Type your ' \
         'choices separated by blank spaces (e.g.: 2 5 6 1). ' \
         'Don\'t repeat colors.'
    puts
    puts "\033[40m  1  \033[0m \e[41m  2  \e[0m \e[42m  3  \e[0m " \
         "\033[43m  4  \033[0m \e[44m  5  \e[0m \e[45m  6  \e[0m " \
         "\033[46m  7  \033[0m \e[30;47m  8  \e[0m"
    guess = gets.chomp.split(' ')
    guess.each_with_index { |val, idx| guess[idx] = val.to_i + 39 }
    self.guesses[round - 1] = guess
  end

  def play_round
    self.pins[round - 1] = []
    guesses[round - 1].each_with_index do |guess, idx_guess|
      model.each_with_index do |color, idx_model|
        if guess == color && idx_guess == idx_model
          self.pins[round - 1][idx_guess] = 'red'
          break
        elsif guess == color && idx_guess != idx_model
          self.pins[round - 1][idx_guess] = 'yellow'
          break
        else
          self.pins[round - 1][idx_guess] = 'white'
        end
      end
    end
  end

  def print_rounds
    (1..round).each do |i|
      code_guesses = ''
      guesses[i - 1].each do |color|
        code_guesses += if color == 47
                          "\e[30;47m  #{color - 39}  \e[0m "
                        else
                          "\e[#{color}m  #{color - 39}  \e[0m "
                        end
      end
      code_pins = ''
      (1..pins[i - 1].count('red')).each { code_pins += "\e[31m \u25CF \e[0m " }
      (1..pins[i - 1].count('yellow')).each { code_pins += "\e[33m \u25CF \e[0m " }
      (1..pins[i - 1].count('white')).each { code_pins += "\e[37m \u25CF \e[0m " }
      puts "Round #{i} of #{rounds}: #{code_guesses} #{code_pins}"
    end
    puts
    puts
    sleep 1
  end

  def checks_result
    if self.pins[round - 1].all?('red')
      puts
      puts 'You win! Congratulations!'
      sleep 1
    else
      puts 'You lose!'
      sleep 1
    end

    puts
    puts 'The secret color code was:'
    code = ''
    model.each do |color|
      code += if color == 47
                "\e[30;47m  #{color - 39}  \e[0m "
              else
                "\e[#{color}m  #{color - 39}  \e[0m "
              end
    end
    puts code
    sleep 1
  end
end
