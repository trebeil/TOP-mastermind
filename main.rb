# frozen_string_literal: true

require_relative './game'

puts 'Hello Player! Welcome to Mastermind!'
sleep 1

loop do
  game = Game.new

  puts
  puts 'How many rounds do you want the game to have?'

  game.define_rounds

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

  game.randomize_model_colors

  puts 'Great, colors chosen! Let\'s start!'
  sleep 1

  loop do
    puts '_________________________________________________________________'
    puts "Round #{game.round} of #{game.rounds}"
    puts
    puts 'Choose a sequence of 4 colors among the options below. Type your ' \
         'choices separated by blank spaces (e.g.: 2 5 6 1). ' \
         'Don\'t repeat colors.'
    puts
    puts "\033[40m  1  \033[0m \e[41m  2  \e[0m \e[42m  3  \e[0m " \
         "\033[43m  4  \033[0m \e[44m  5  \e[0m \e[45m  6  \e[0m " \
         "\033[46m  7  \033[0m \e[30;47m  8  \e[0m"

    game.choose_colors
    game.play_round
    game.print_rounds
    puts
    puts
    sleep 1
    break if game.round == game.rounds || game.pins[game.round - 1].all?('red')

    game.round += 1
  end

  game.checks_result
  sleep 1

  puts
  puts 'Do you want to play again? [y/n]'

  play_again = gets.chomp

  break if play_again == 'n'
end
