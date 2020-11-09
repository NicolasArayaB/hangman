module Setup
  $block = "-------------------"

  def welcome
    puts $block.center(120)
    puts "Welcome to Hangman!".center(120)
    puts $block.center(120)
  end

  def options
    puts "What do you want to do?"
    puts "1- New game"
    puts "2- Load game"
    puts "3- Quit"
    input = gets.chomp.downcase
    choise(input)
  end

  def random_word
    dict = File.read("5desk.txt").split
    count = 0
    dict.each { |w| count += 1 if w }
    word = dict[rand(count)]
    if word.size > 4 && word.size < 13
      valid_word = word
    else
      random_word
    end
  end

  def hide(word)
    hidden_word = []
    word.each_char { |char| hidden_word << "_" }
    hidden_word.join(" ")
  end

  def guess_error
    puts "That's not a valid guess!"
  end

  def turns_left
    puts "You have #{@turn} turns left"
  end

  def winner
    puts $block.center(120) 
    puts "You are the winner!".center(120)
    puts $block.center(120)
  end

  def g_o
    puts "Game Over".center(120)
  end
end
