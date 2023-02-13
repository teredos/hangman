# frozen_string_literal: true

require_relative 'data'
require 'fileutils'

# creates a game of Hangman
class Hangman
  include Data

  def initialize
    words_list = File.readlines('google-10000-english-no-swears.txt')
    @secret_word = secret_word(words_list)
    @hidden_word = Array.new(@secret_word.length, '_')
    @incorr_letters = []
    play_game
  end

  def play_game
    load_game? && confirm_decision? ? load_game : (puts introduction)
    while @incorr_letters.length < 6 && @hidden_word != @secret_word
      if save_game? && confirm_decision?
        save_game
        continue_game?
      end
      play_round
      puts game_status
    end
    announce_winner
  end

  def secret_word(words)
    words.select! { |l| l.gsub!(/\s+/, '').length.between?(5, 12) }.sample.chars
  end

  def introduction
    "Welcome to Hangman. Your objective is to decipher the Computer's word " \
      'using the alphabet. You can input 6 incorrect letter guesses before ' \
      'you lose. Good luck.'
  end

  def play_round
    puts 'Input your letter (case insensitive):'
    letter_guess = gets.chomp.downcase
    update_game(letter_guess)
  end

  def game_status
    "      #{@hidden_word.join(' ')}        " \
      "\nIncorrect letters: #{@incorr_letters}. You have " \
      "#{6 - @incorr_letters.length} incorrect guesses left."
  end

  def letter_checked_error
    'This letter has already been checked. Pick another letter.'
  end

  def play_again?
    puts 'Would you like to play again? [Y/n]'
    response = gets.chomp
    ['Y', 'y', ''].include?(response)
  end

  def confirm_decision?
    puts 'Are you sure? [Y/n]'
    response = gets.chomp
    ['Y', 'y', ''].include?(response)
  end

  def continue_game?
    puts 'Would you like to continue the game?'
    response = gets.chomp
    exit unless ['Y', 'y', ''].include?(response)
  end

  def no_more_letters?
    @incorr_letters.length == 6
  end

  def word_solved?
    @hidden_word == @secret_word
  end

  def user_loses
    puts "You failed to decipher the Computer's word of " \
         "#{@secret_word.join.upcase}"
    Hangman.new if play_again?
  end

  def user_wins
    puts "You deciphered the Computer's word of #{@secret_word.join.upcase}!"
    Hangman.new if play_again?
  end

  def announce_winner
    user_loses if no_more_letters?
    user_wins if word_solved?
  end

  def update_game(guess)
    if @secret_word.include?(guess)
      check_hidden_word(guess)
    elsif ('a'..'z').to_a.include?(guess)
      check_incorr_letters(guess)
    else
      puts 'Invalid character. Only enter a letter between A-Z.'
      play_round
    end
  end

  def update_hidden_word(guess)
    @secret_word.each_with_index do |elem, i|
      @hidden_word[i] = elem if elem == guess
    end
  end

  def check_hidden_word(guess)
    if @hidden_word.include?(guess)
      puts letter_checked_error
      play_round
    else
      update_hidden_word(guess)
    end
  end

  def check_incorr_letters(guess)
    if @incorr_letters.include?(guess.upcase)
      puts letter_checked_error
      play_round
    else
      @incorr_letters << guess.upcase
    end
  end
end

Hangman.new
