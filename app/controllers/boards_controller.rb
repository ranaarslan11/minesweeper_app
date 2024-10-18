class BoardsController < ApplicationController
  before_action :find_board, except: :index
  def index
    @recent_boards = Board.order(created_at: :desc).limit(10)
    @board = Board.new
  end

  def create
    @board = Board.new(board_params)
    @board.generate_board
    if @board.save
      redirect_to @board
    else
      render :index
    end
  end

  def show
  end

  def reveal_cell
    row = params[:row].to_i
    col = params[:col].to_i

    if @board.board_data[row][col] == 'M'
      @board.game_over = true
    end

    @board.revealed_data[row][col] = true
    @board.save
    render json: { game_over: @board.game_over, cell_value: @board.board_data[row][col] }
  end

  private

  def find_board
    @board = Board.find_by id: params[:id]
  end

  def board_params
    params.require(:board).permit(:name, :email, :width, :height, :mines)
  end
end
