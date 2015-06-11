module Layoutcalculations
  extend ActiveSupport::Concern
  
  def column_height(size, columns = 3)
  	# create a rounding value to set number of entries in each column
    return ( size / columns) + (size % columns == 0 ? 0 : 1)
  end
end