class Hangman
    attr_accessor :secret_word
    def initialize(secret_word)
      @secret_word = secret_word
      @letters = []
    end

    def process_word_and_start_game
        p @secret_word
        @secret_array = @secret_word.split('')
        @hangman_hide_array = Array.new(@secret_word.length, '_')
        p @hangman_hide_string = @hangman_hide_array.join(' ')
        @updated_secret = @hangman_hide_array.clone 

        ask_guess()
    end

    def ask_guess 
        puts "Escolha uma letra:"
        @answer = gets.chomp.downcase
        @indexes_guess = []
        if @secret_array.include?(@answer)
            @secret_array.each_with_index do |char, index|
                if char == @answer
                    @indexes_guess << index
                end
            end
        end
        @indexes_guess
        display_responses(@indexes_guess, @answer)
        list_letters(@answer)
        
    end

   

    def display_updated_secret

    end

    def display_responses(indexes_list, char)
            

        if indexes_list.empty?
          p "A letra '#{char}' não faz parte da palavra..." 
        elsif indexes_list.length == 1 
          p "A letra '#{char}' aparece 1 vez nesta palavra!"
          @updated_secret[indexes_list[0]] = char 
        elsif indexes_list.length > 1
          p "A letra '#{char}' aparece #{indexes_list.length} vezes na palavra!!!"
          indexes_list.each do |number|
             @updated_secret.each_with_index do |space, i|
                if i == number
                    @updated_secret[i] = char 
                end
             end
          end
        end
        
         p @updated_secret.join(' ')
    end

    def list_letters(letter)
        @letters << letter
        
        p "Letras já escolhidas: #{@letters.join(', ')}"
        ask_guess()
    end
end



dictionary = File
            .read('/home/ricardo1/rubyTOP/event_manager/hangman/google-10000-english-no-swears.txt')
            .split(/\n/)


secret_word = dictionary.sample
Hangman.new(secret_word).process_word_and_start_game






