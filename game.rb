class Game
  attr_accessor :colors_found, :guesses, :model, :pins, :round, :rounds, :universe, :universe_iterator
  attr_reader :mode

  def initialize(mode)
    @guesses = []
    @pins = []
    @round = 1
    @mode = mode
    @universe = []
    @colors_found = false
    @universe_iterator = 0
  end

  def define_rounds
    self.rounds = gets.chomp.to_i
    until /^[1-9]{1,}?/.match?(self.rounds.to_s)
      puts
      puts 'Please input number of rounds greater than 0:'
      self.rounds = gets.chomp.to_i
    end
  end

  def choose_random_colors
    puts
    puts 'Ok, now the computer will select the colors!'
    puts 'Selecting colors...'
    sleep 1
    puts '...'
    sleep 1
    array = Array.new(4)
    array.each_index { |i| array[i] = Random.new.rand(40..47) }
  end

  def player_choose_colors
    puts
    puts 'Choose a sequence of 4 colors among the options below. Type your ' \
    'choices separated by blank spaces (e.g.: 2 5 6 1). ' \
    'Repeated colors are allowed.'
    puts
    puts "\033[40m  1  \033[0m \e[41m  2  \e[0m \e[42m  3  \e[0m " \
        "\033[43m  4  \033[0m \e[44m  5  \e[0m \e[45m  6  \e[0m " \
        "\033[46m  7  \033[0m \e[30;47m  8  \e[0m"
    array = gets.chomp.split(' ')
    until /^[1-8]{1} [1-8]{1} [1-8]{1} [1-8]{1}$/.match?(array.join(' '))
      puts
      puts 'Invalid choice! Choose a sequence of 4 colors among the options ' \
        'below. Type your choices separated by blank spaces (e.g.: 2 5 6 1).'
      puts
      puts "\033[40m  1  \033[0m \e[41m  2  \e[0m \e[42m  3  \e[0m " \
          "\033[43m  4  \033[0m \e[44m  5  \e[0m \e[45m  6  \e[0m " \
          "\033[46m  7  \033[0m \e[30;47m  8  \e[0m"
      array = gets.chomp.split(' ')
    end
    array.each_with_index { |val, idx| array[idx] = val.to_i + 39 }
  end

  def computer_choose_colors
    if round == 1
      [40, 40, 40, 40]
    elsif pins[round - 2].count('red') + pins[round - 2].count('yellow') < 4
      pins_last_round = pins[round - 2].count('red') + pins[round - 2].count('yellow')
      guesses[round - 2].map.with_index { |val, i| i <= pins_last_round - 1 ? val : val + 1 }
    else
      if colors_found == false
        (1234..4321).each do |i|
          indexes = i.to_s.split('').map(&:to_i)
          if indexes.count(1) == 1 && indexes.count(2) == 1 &&
             indexes.count(3) == 1 && indexes.count(4) == 1
            self.universe.push([guesses[round - 2][indexes[0] - 1], guesses[round - 2][indexes[1] - 1],
                                guesses[round - 2][indexes[2] - 1], guesses[round - 2][indexes[3] - 1]])
          end
        end
        self.universe = universe.uniq
        colors_found == true
      end
      yellows_last_round = pins[round - 2].count('yellow')
      if yellows_last_round == 4
        self.universe.reject! do |el|
          el[0] == guesses[round - 2][0] || el[1] == guesses[round - 2][1] ||
            el[2] == guesses[round - 2][2] || el[3] == guesses[round - 2][3]
        end
        self.universe_iterator = -1
      end
      self.universe_iterator += 1
      universe[universe_iterator]
    end
  end

  def play_round
    self.pins[round - 1] = []
    guess_copy = guesses[round - 1].clone
    model_copy = model.clone
    i = 0
    while i < guess_copy.length
      if guess_copy[i] == model_copy[i]
        self.pins[round - 1].push('red')
        model_copy.delete_at(i)
        guess_copy.delete_at(i)
        i -= 1
      end
      i += 1
    end
    i = 0
    while i < guess_copy.length
      if model_copy.any?(guess_copy[i])
        self.pins[round - 1].push('yellow')
        model_copy.delete_at(model_copy.index(guess_copy[i]))
        guess_copy.delete_at(i)
        i -= 1
      end
      i += 1
    end
    guess_copy.each { self.pins[round - 1].push('white') }
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
  end

  def checks_result
    if (mode == 1 && self.pins[round - 1].all?('red')) ||
       (mode == 2 && !self.pins[round - 1].all?('red'))
      puts
      puts 'You win! Congratulations!'
    else
      puts 'You lose!'
    end
    sleep 1
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
  end
end
