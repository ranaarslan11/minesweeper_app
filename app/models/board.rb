class Board < ApplicationRecord
  serialize :board_data, Array, coder: YAML
  serialize :revealed_data, Array, coder: YAML
  serialize :flagged_data, Array, coder: YAML

  def generate_board
    grid = Array.new(height) { Array.new(width, 0) }

    mines_placed = 0
    while mines_placed < mines
      row = rand(height)
      col = rand(width)
      unless grid[row][col] == 'M'
        grid[row][col] = 'M'
        mines_placed += 1
        update_adjacent_cells(grid, row, col)
      end
    end

    self.board_data = grid

    self.revealed_data = Array.new(height) { Array.new(width, false) }
    self.flagged_data = Array.new(height) { Array.new(width, false) }
  end

  private

  def update_adjacent_cells(grid, row, col)
    (-1..1).each do |i|
      (-1..1).each do |j|
        next if i == 0 && j == 0
        new_row, new_col = row + i, col + j
        if new_row.between?(0, height - 1) && new_col.between?(0, width - 1) && grid[new_row][new_col] != 'M'
          grid[new_row][new_col] += 1
        end
      end
    end
  end
end
