# frozen_string_literal: true

require_relative './game'

puts 'Hello Player! Welcome to Mastermind!'
sleep 1

loop do
  puts
  puts 'Which game mode do you want to play?'
  puts '[1] I want to be the guesser of the secret code'
  puts '[2] I want to be the creator of the secret code'
  mode = gets.chomp.to_i
  until /^[12]{1}$/.match?(mode.to_s)
    puts
    puts 'Please choose a valid option. Which game mode do you want to play?'
    puts '[1] I want to be the guesser of the secret code'
    puts '[2] I want to be the creator of the secret code'
    mode = gets.chomp.to_i
  end

  game = Game.new(mode)

  puts
  puts 'How many rounds do you want the game to have?'

  game.define_rounds

  game.model = if game.mode == 1
                 game.choose_random_colors
               else
                 game.player_choose_colors
               end

  puts 'Great, color code chosen! Let\'s start!'
  sleep 1

  loop do
    puts '_________________________________________________________________'
    puts "Round #{game.round} of #{game.rounds}"

    game.guesses[game.round - 1] = if game.mode == 1
                                     game.player_choose_colors
                                   else
                                     game.computer_choose_colors
                                   end
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
