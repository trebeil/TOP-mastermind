require_relative 'game.rb'

puts 'Hello Player! Welcome to Mastermind!'
sleep 1

loop do
  game = Game.new
  game.define_rounds
  game.randomize_model_colors
  loop do
    game.choose_colors
    game.play_round
    game.print_rounds
    break if game.round == game.rounds || game.pins[game.round - 1].all?('red')

    game.round += 1
  end
  game.checks_result
  puts
  puts 'Do you want to play again? [y/n]'
  play_again = gets.chomp
  break if play_again == 'n'
end
