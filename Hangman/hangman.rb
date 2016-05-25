class Game
	attr_accessor :used_letters, :secret_word, :turns_left, :encrypted_word, :new_word
	def initialize
		@dictionary= File.read "5text.txt"
		@dictionary= @dictionary.split(' ')
		secret_word
		encrypt
		player_guess
		@turns_left=9
		@used_letters= []
		play
	end

	def secret_word
		@secret_word = @dictionary.sample.downcase
		if @secret_word.length > 12 
			@secret_word
		end
		@secret_word=@secret_word.split('')
		puts ""
		#puts @secret_word.join('')
		puts "Welcome To Hangman!"
		puts "Try to guess the word one letter at a time."
		puts "You can type 'exit' at any time to leave the game."
		puts "Good luck!"
		puts ' '
	end
	def encrypt
		@encrypted_word = @secret_word.join(" ").gsub(/\w/, '_')
		puts @encrypted_word
	end

	def player_guess
		puts "You only have #{@turns_left} turns left before you die."
		puts "Used Letters:  #{@used_letters}"
		#puts @encrypted_word
		@guess = gets.chomp
		if @guess == "exit"
			throw :done
		end
		#@guess = @guess.split('')
	end

	def re_do
		puts "Would you like to try again?"
		answer=gets.chomp
		if answer=="yes"
			Game.new
		else
			throw :done
		end
	end

	def play
		catch (:done) do
			while @turns_left >1
				if @guess.length ==0
					puts "You need to enter something"
					player_guess
				elsif @guess.length >1
					puts "One character at a time please"
					player_guess
				elsif @secret_word.include? @guess
					puts "\nIts in there!"
					puts " "
					updated_word
					player_guess
				elsif @used_letters.include? @guess
					puts "\nYou have already used that"
					@turns_left = @turns_left -1
					player_guess
				else
					puts "\nNope"
					puts ' '
					@used_letters = @used_letters + @guess.split('')
					@turns_left = @turns_left -1
					puts @encrypted_word
					player_guess
					
				end
			end
			puts "Sorry, you have hung for your spelling related crimes. The word was #{@secret_word.join('')}"
			re_do
		end
	end

	def updated_word
		new_word=""
		@new_word=new_word
		old_word= @encrypted_word.split(" ").join
		@secret_word.each_with_index do |letter, index|
			if @guess == letter
				new_word += " #{letter}"
			elsif "_"!=old_word[index]
				new_word +=" #{old_word[index]}"
			else
				new_word +=" _"
			end
		end
		@encrypted_word= new_word[1..-1]
		puts new_word
		if @encrypted_word == @secret_word.join(" ")
			puts "Congratulations! You have won! You may now return to your home, a free man."
			puts " "
			re_do
		end

	end
end

Game.new