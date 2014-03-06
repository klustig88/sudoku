class Sudoku
  def initialize(board_string)
    @original_board = board_string.each_char.to_a.collect{|string|string.to_i}
    @working_board = Array.new(9) { Array.new(9) }
    @cell = 1
  end
 
  def solve!
  end
 
  # Returns a string representing the current state of the board
  # Don't spend too much time on this method; flag someone from staff
  # if you are.
  def build_board
    @original_board
    @working_board.collect! { |row|
      row.collect! { |cell|
        cell = @original_board.shift
      }
    }
    @working_board
  end
 
  def next_cell(index=[0,0])
 
 
    #return indexes in form [x,y]
    cell_index = grab_cell(@working_board) 
 
    # # return array of numbers in respective row
    row = grab_row(cell_index)
 
    # #return array of numbers in respective column
    column = grab_column(cell_index)
 
    # #return array of numbers in respective block
    block = grab_block(cell_index)
 
    # #returns either a unique # if found or 0
    result_number = merge_arrays(row, column, block)
 
    # #fills returned number into respective cell on working board
    fill_cell(cell_index, result_number)
 
    # #check if any zeros remain on the working board
    check_board(cell_index)
 
 
  end
 
  def switch_cells
   @working_board.collect! { |row|
              row.collect! { |cell|
                if cell == -1
                  cell = 0
                else
                  cell = cell
                end
              }
            }
  
  next_cell    
  end
 
  def grab_cell(board)
    zeros = []
    current_row = 0                                                       
    board.collect { |row|
      if row.find_index(0).nil?
        current_row +=1
        next
      else
        zeros << current_row
        zeros << row.find_index(0)
        current_row +=1
      end
 
    }
    index = zeros.slice(0,2)
  end
 
  def grab_row(index)
    @working_board[index[0]]
  end
 
  def grab_column(index)
    # p index
    column = []
    @working_board.collect {|row|
      column << row[index[1]]
    }
    column
  end
 
  def grab_block(index)
    block = []
    checks = [2,5,8]
    current_row = index[0]
    current_column = index[1]
 
    8.times do  
      if !checks.include?(current_column)
        current_column += 1
 
      elsif !checks.include?(current_row)
        current_column = current_column-2
        current_row += 1
 
      else
      current_column = current_column-2
      current_row = current_row-2
    end
      @working_board[current_row][current_column]
      block << @working_board[current_row][current_column]
    end
    block
  end
 
  def merge_arrays(row, column, block)
    test_array = (1..9).to_a
 
    combined_array = [row,column,block].flatten.uniq
 
    final_set = test_array - combined_array
 
 
    if final_set.length == 1
      return final_set[0]
    else
      return -1
    end
 
  end
 
  def fill_cell(index, number)
    x = index[0]
    y = index[1]
    @working_board[x][y] = number
 
  end
 
  def check_board(index)
 
    if @working_board.flatten.include?(0)
      @working_board.flatten
      @cell +=1
      next_cell(index)
    elsif @working_board.flatten.include?(-1)
      switch_cells
    else
      puts "Finished Board"
      p @working_board
    end
  
end
 
end
 
# The file has newlines at the end of each line, so we call
# String#chomp to remove them.
board_string = File.readlines('sample.unsolved.txt').first.chomp
 
game = Sudoku.new(board_string)
 
game.build_board
# Remember: this will just fill out what it can and not "guess"
game.next_cell
