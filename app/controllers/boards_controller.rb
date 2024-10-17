class BoardsController < ApplicationController
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
    @board = Board.find(params[:id])
  end

  def reveal_cell
    @board = Board.find(params[:id])
    row = params[:row].to_i
    col = params[:col].to_i

    if @board.board_data[row][col] == 'M'
      render json: { game_over: true }
    else
      @board.revealed_data[row][col] = true
      @board.save
      render json: { game_over: false, cell_value: @board.board_data[row][col] }
    end
  end

  private

  def board_params
    params.require(:board).permit(:name, :email, :width, :height, :mines)
  end
end
