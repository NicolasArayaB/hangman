require_relative "./setup.rb"
require "yaml"

class Game
  attr_accessor :hidden_word, :turn, :wrong_char
  attr_reader :word

  include Setup
  
  def initialize
    @word = random_word.downcase
    @hidden_word = hide(word)
    @turn = 6
    @wrong_char = []
    welcome
    options
  end

  def choise(input)
    if input == "1" || input == "new game"
      turn
    elsif input == "2" || input == "load game"
      load
      turn
    elsif input == "3" || input == "quit"
      g_o
    else
      guess_error
      input = gets.chomp.downcase
      choise(input)
    end
  end

  def turn
    display
    guessing
    win
    game_over
  end

  def hidden_word
    puts @hidden_word
  end

  def display
    puts "You can always save your game, just write \"save\" at any time."
    hidden_word
    puts @wrong_char.join(" ")
    turns_left
  end

  def guessing
    guess = gets.chomp.downcase
    valid_guess(guess)
    if @word.include?(guess)
      correct_guess(@word, guess)
    else
      incorrect_guess(guess)
    end
  end

  def valid_guess(guess)
    if guess.size > 1 && guess.size != 4
      guess_error
      guessing
    elsif guess.size == 0
      guess_error
      guessing
    elsif !guess.match?(/[a-z]/)
      guess_error
      guessing
    elsif guess == "save"
      save
    elsif guess == "load"
      load
    end
  end

  def correct_guess(word, char)
    word.each_char.with_index { |c, i|
      if c == char
        hidden_arr = @hidden_word.split
        hidden_arr[i] = char
        @hidden_word = hidden_arr.join(" ")
      end }
  end

  def incorrect_guess(char)
    @wrong_char << char
    @turn -= 1
  end

  def win
    hidden = @hidden_word.split(" ").join
    if @word == hidden
      puts @hidden_word
      winner
      exit
    end
  end

  def game_over
    if @turn == 0
      p "The word was: #{@word}!"
      g_o
    else
      turn
    end
  end

  def save
    save_file = YAML.dump({
      word: @word,
      hidden_word: @hidden_word,
      turn: @turn,
      wrong_char: @wrong_char
    })
    File.open("game.csv", "w") { |f| f.write save_file }
    exit
  end

  def load
    data = File.open("game.csv", "r") { |f| YAML.load(f) }
    
    @word = data[:word]
    @hidden_word = data[:hidden_word]
    @turn = data[:turn]
    @wrong_char = data[:wrong_char]
  end
end
