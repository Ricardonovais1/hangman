require 'yaml'

class Hangman 
    attr_accessor :secret_word

    def initialize(secret_word = nil)
        @secret_word = secret_word
        @typed = []
        @lives = 10
    end

    def start_game 
        @word_array = Array.new(@secret_word.length, '_')
        @secret_array = @secret_word.split('')

        play(@word_array.join(' '), @typed, @lives)
    end

    def play(frame, typed, lives)
        puts `clear`
        puts "FIND THE SECRET WORD ::: Letters you typed: #{typed.join(', ')}"
        puts
        puts frame
        puts 
        check_win
        puts "Type a letter (or 'save' to continue later):"
        @guess = gets.chomp.downcase
        if @guess != 'save' && !@typed.include?(@guess)
            typed << @guess 
        elsif @guess == 'save'
            save_info
        end
        @indexes_guess = []

        if @secret_array.include?(@guess)
            @secret_array.each_with_index do |letter, i|
               @indexes_guess << i if letter == @guess 
            end
        end
        @lives -= 1        

        if @lives < 1
            puts `clear`
            abort("GAME OVER, YOU RAN OUT OF LIVES, THE SECRET WORD IS '#{@secret_word}'")  
        end
        

        sub_spaces_for_letters(@indexes_guess, @guess)
    end

    def sub_spaces_for_letters(indexes, guess)

        
        indexes.each do |n|
            @word_array.each_index do |i|
                @word_array[i] = guess if n == i
            end
        end

        play(@word_array.join(' '), @typed, @lives)
    end

    def check_win 
        puts "You have #{@lives} left"
        puts
        if @lives >= 1 && !@word_array.any? { |el| el == '_' }
            puts `clear`
            puts "YOU WON! THE WORD IS '#{@secret_word}'" 
            puts "YOU DID IT IN #{10 - @lives} TRYS. GOOD JOB!"
            exit
        end
    end

    def save_info
        puts "Qual é o nome do arquivo?"
        filename = gets.chomp.downcase
        to_yaml(filename)
        puts `clear`
        abort("Até breve!")
    end

    def to_yaml(filename)
        Dir.mkdir('saved_games_2') unless Dir.exist?('saved_games_2')
        f = File.open("/home/ricardo1/rubyTOP/event_manager/hangman/saved_games_2/#{filename}.yml", "w")
        YAML.dump({
            secret_word: @secret_word,
            word_array: @word_array,
            typed: @typed,
            lives: @lives,
            secret_array: @secret_array,
            word_frame: @word_frame,
            indexes_guess: @indexes_guess          
        }, f)
        f.close
        puts `clear`
    end

    def load_game 
        unless Dir.exist?('/home/ricardo1/rubyTOP/event_manager/hangman/saved_games_2')
            puts 'Nenhum jogo salvo. Inicie um novo jogo...'
            exit
          end
          games = saved_games
          puts games
          load_file
    end

    def load_file 
        puts "Qual é o nome do seu jogo?"
        file_name = gets.chomp.downcase
        if @game_list.include?(file_name) 
            deserialize(file_name)        
        else 
            puts 'This game does not exist' 
        end
    end

    def deserialize(file_name)
        yaml = YAML.load(File.read("/home/ricardo1/rubyTOP/event_manager/hangman/saved_games_2/#{file_name}.yml"))
        @secret_word = yaml[:secret_word]
        @word_array = yaml[:word_array]
        @typed = yaml[:typed]
        @lives = yaml[:lives]
        @secret_array = yaml[:secret_array]
        @word_frame = yaml[:word_frame]
        @indexes_guess = yaml[:indexes_guess]
        puts `clear`
        play(@word_array.join(' '), @typed, @lives)    
    end

    def saved_games
       puts 'Jogos salvos: '
       @game_list = Dir['/home/ricardo1/rubyTOP/event_manager/hangman/saved_games_2/*'].map { |file| file.split('/')[-1].split('.')[0] }      
      end
end


dictionary = File
            .read('/home/ricardo1/rubyTOP/event_manager/hangman/google-10000-english-no-swears.txt')
            .split(/\n/)

secret_word = dictionary.sample



puts 'WELCOME TO HANGMAN (JOGO DA FORCA)! BORA TREINAR INGLÊS?'
puts
puts 'Please type:'
puts "(1) To play a new game"
puts "(2) To load a saved game"
decision = gets.chomp
if decision == '1'
    puts `clear`
    Hangman.new(secret_word).start_game
elsif decision == '2'
    Hangman.new.load_game
end
