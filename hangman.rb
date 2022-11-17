class Hangman
    # attr_accessor :secret_word
    def initialize(secret_word)
      @secret_word = secret_word
      @letters = []
      @guesses_count = 5
    end

    def process_word_and_start_game
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

    def wanna_guess_question 
        if @guesses_count == 0 
            abort("FIM DE JOGO: TENTATIVAS EXCEDIDAS...")
        end
        puts "Você tem direito a #{@guesses_count} tentativas"

        puts "Quer adivinhar a palavra? s/n"
        y_n = gets.chomp.downcase
        if y_n == 's' 
            @guesses_count -= 1
            test_guess()
        elsif y_n == 'n' 
            ask_guess()
        else  
            puts "Foi uma pergunta de sim ou não. Bola pra frente:"
        end  
        ask_guess()
    end

    def test_guess
       puts "ESCREVA A PALAVRA:"
       @guess = gets.chomp.downcase
       if @guess == @secret_word
         abort("PARABÉNS VOCÊ VENCEU, NA TENTATIVA #{5 - @guesses_count}/5")
       else  
         puts "Ainda não foi dessa vez. Você possui mais #{@guesses_count} tentativas."
         ask_guess()
       end
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

        if @updated_secret.include?('_') == false
            abort("FIM DE JOGO, VOCÊ NÃO CONSEGUIU ACERTAR. A PALAVRA É '#{@secret_word.upcase}'")
        else    
            p @updated_secret.join(' ')
        end
    end

    def list_letters(letter)

        if @letters.include?(letter) 
            puts "Esta letra já foi escolhida"
        else  
            @letters << letter
        end
        
        p "Letras já escolhidas: #{@letters.join(', ')}"
        wanna_guess_question()
    end
end



dictionary = File
            .read('/home/ricardo1/rubyTOP/event_manager/hangman/google-10000-english-no-swears.txt')
            .split(/\n/)


secret_word = dictionary.sample
Hangman.new(secret_word).process_word_and_start_game







