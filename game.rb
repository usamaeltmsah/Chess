require_relative 'board'
require_relative 'display'
require_relative 'human_player'

class Game
    attr_reader :board, :display, :players, :cur_player
    def initialize
        @board = Board.new
        @display = Display.new(@board)
        @players = { 
            white: HumanPlayer.new(:white, @display),
            black: HumanPlayer.new(:black, @display)
        }
        @cur_player = :white
    end

    def play
        until board.checkmate?(cur_player)
            begin
                start_pos, end_pos = players[cur_player].make_move(board)
                board.move_piece(cur_player, start_pos, end_pos)
                swap_turn!
                notify_players
            rescue => exception
                @display.notifications[:error] = exception.message
                retry
            end
        end
        display.render
        puts "#{cur_player} is checkmated!"
        nil
    end

    def swap_turn!
        @cur_player = cur_player == :white ? :black : :white
    end

    def notify_players
        if board.in_check?(cur_player)
            display.set_check!
        else
            display.uncheck!
        end
    end
end