# frozen_string_literal: true

require 'json'

# includes save and load methods
module Data
  def load_game?
    puts 'Would you like to load a previous game? [Y/n]'
    response = gets.chomp
    ['Y', 'y', ''].include?(response)
  end

  def load_game
    if Dir.glob('saves/*.json').empty?
      puts 'You have no saves!'
    else
      load_from_json(File.read(load_choice))
    end
  end

  def load_choice
    puts 'Which save would you like to load?'
    puts Dir.glob('saves/*.json')
    choice = gets.chomp
    until Dir.glob('saves/*.json').include?(choice)
      puts 'Invalid response: Please make sure to provide the full save ' \
           '(including the path):'
      choice = gets.chomp
    end
    choice
  end

  def load_from_json(string)
    data = JSON.parse(string)
    @secret_word = data['secret_word']
    @hidden_word = data['hidden_word']
    @incorr_letters = data['incorr_letters']
  end

  def save_game?
    puts 'Would you like to save the game? [Y/n]'
    response = gets.chomp
    ['Y', 'y', ''].include?(response)
  end

  def save_game
    FileUtils.mkdir_p('saves')
    puts 'What would you like your save to be called?'
    filename = "saves/#{gets.chomp}.json"
    File.open(filename, 'w') { |file| file.puts save_to_json }
    puts "Your game has been saved at #{filename}"
  end

  def save_to_json
    JSON.dump({
                secret_word: @secret_word,
                hidden_word: @hidden_word,
                incorr_letters: @incorr_letters
              })
  end
end
