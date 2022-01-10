require "./common"

module Geode
  # Common operations for matrices.
  #
  # Intended to be used as a mix-in on matrix types.
  # *M* and *N* are the number of rows and columns respectively.
  module MatrixOperations(M, N)
    # Returns a matrix containing the absolute value of each element.
    #
    # ```
    # Matrix[[-5, 42], [0, -20]].abs # => [[5, 42], [0, 20]]
    # ```
    def abs : self
      map &.abs
    end

    # Returns a matrix containing the square of each element.
    #
    # ```
    # Matrix[[-5, 3], [0, -2]].abs2 # => [[25, 9], [0, 4]]
    # ```
    def abs2 : self
      map &.abs2
    end

    # Returns a matrix with each element rounded.
    #
    # See `Number#round` for details.
    #
    # ```
    # Matrix[[1.2, -5.7], [3.0, 1.5]].round # => [[1.0, -6.0], [3.0, 2.0]]
    # ```
    def round(mode : Number::RoundingMode = :ties_even) : self
      map &.round(mode)
    end

    # Returns a matrix with each element rounded.
    #
    # See `Number#round` for details.
    #
    # ```
    # Matrix[[1.25, -5.77], [3.01, 0.1]].round(1) # => [[1.3, -5.8], [3.0, 0.1]]
    # ```
    def round(digits : Number, base = 10, *, mode : Number::RoundingMode = :ties_even) : self
      map &.round(digits, base, mode: mode)
    end

    # Returns a matrix with elements equal to their original sign.
    #
    # 1 is used for positive values, -1 for negative values, and 0 for zero.
    #
    # ```
    # Matrix[[5, 0], [-1, -5]] # => [[1, 0], [-1, -1]]
    # ```
    def sign : self
      map &.sign
    end

    # Returns a matrix with elements rounded up to the nearest integer.
    #
    # ```
    # Matrix[[1.2, -5.7], [3.0, 0.1]] # => [[2.0, -5.0], [3.0, 1.0]]
    # ```
    def ceil : self
      map &.ceil
    end

    # Returns a matrix with elements rounded down to the nearest integer.
    #
    # ```
    # Matrix[[1.2, -5.7], [3.0, 0.1]] # => [[1.0, -6.0], [3.0, 0.0]]
    # ```
    def floor : self
      map &.floor
    end

    # Returns a matrix with the fraction from each element.
    #
    # This is effectively equal to:
    #
    # ```text
    # fraction(v) = v - floor(v)
    # ```
    #
    # ```
    # Matrix[[1.2, -5.7], [3.0, 0.1]] # => [[0.2, 0.3], [0.0, 0.1]]
    # ```
    def fraction : self
      self - floor
    end

    # Returns a matrix restricted to the minimum and maximum values from other matrices.
    #
    # ```
    # min = Matrix[[-1, -1], [-1, -1]]
    # max = Matrix[[1, 1], [1, 1]]
    # Matrix[[5, -2], [0, 1]].clamp(min, max) # => [[1, -1], [0, 1]]
    # ```
    def clamp(min : CommonMatrix(T, M, N), max : CommonMatrix(T, M, N)) : CommonMatrix forall T
      same_size!(M, N)

      map_with_index do |element, index|
        lower = min.unsafe_fetch(index)
        upper = max.unsafe_fetch(index)
        element.clamp(lower, upper)
      end
    end

    # Returns a matrix restricted to the range from other matrices.
    #
    # ```
    # min = Matrix[[-1, -1], [-1, -1]]
    # max = Matrix[[1, 1], [1, 1]]
    # Matrix[[5, -2], [0, 1]].clamp(min..max) # => [[1, -1], [0, 1]]
    # ```
    def clamp(range : Range(CommonMatrix(T, M, N), CommonMatrix(T, M, N))) : CommonMatrix forall T
      raise ArgumentError.new("Can't clamp an exclusive range") if !range.end.nil? && range.exclusive?
      clamp(range.begin, range.end)
    end

    # Returns a matrix restricted to min and max values.
    #
    # *min* and *max* should be scalar values.
    # Each element of the matrix is clipped to these same values.
    #
    # ```
    # Matrix[[5, -2], [0, 1]].clamp(-1, 1) # => [[1, -1], [0, 1]]
    # ```
    def clamp(min, max) : CommonMatrix
      map &.clamp(min, max)
    end

    # Returns a matrix restricted to a range.
    #
    # The range should consist of scalar values.
    # Each element of the matrix is clipped to the same range.
    #
    # ```
    # Matrix[[5, -2], [0, 1]].clamp(-1..1) # => [[1, -1], [0, 1]]
    # ```
    def clamp(range : Range) : CommonMatrix
      raise ArgumentError.new("Can't clamp an exclusive range") if !range.end.nil? && range.exclusive?
      clamp(range.begin, range.end)
    end

    # Returns a new matrix where each element is 0 if it's less than the edge value, or 1 if it's greater.
    #
    # ```
    # Matrix[[0, 1], [2, 3]].edge(2) # => [[0, 0], [1, 1]]
    # ```
    def edge(edge : T) : self forall T
      map { |v| v < edge ? T.zero : T.new(1) }
    end

    # Returns a new matrix where each element is 0 if it's less than the corresponding edge value, or 1 if it's greater.
    #
    # ```
    # Matrix[[0, 1], [2, 3]].edge(Matrix[[3, 2], [1, 0]]) # => [[0, 0], [1, 1]]
    # ```
    def edge(edge : CommonMatrix(T, M, N)) : self forall T
      zip_map(edge) { |v, e| v < e ? T.zero : T.new(1) }
    end

    # Returns a matrix with each element scaled by the corresponding element value.
    #
    # ```
    # Matrix[[1, 0], [-1, -2]].scale(Matrix[[2, 3], [5, 1]]) # => [[2, 0], [-5, -2]]
    # ```
    def scale(matrix : CommonMatrix(T, M, N)) : CommonMatrix forall T
      zip_map(matrix) { |a, b| a * b }
    end

    # Returns a matrix with each element scaled by the corresponding element value.
    #
    # Values will wrap instead of overflowing and raising an error.
    #
    # ```
    # Matrix[[1, 0], [-1, -2]].scale!(Matrix[[2, 3], [5, 1]]) # => [[2, 0], [-5, -2]]
    # ```
    def scale!(matrix : CommonMatrix(T, M, N)) : CommonMatrix forall T
      zip_map(matrix) { |a, b| a &* b }
    end

    # Scales each element by the specified amount.
    #
    # ```
    # Matrix[[5, -2], [0, 1]].scale(3) # => [[15, -6], [0, 3]]
    # ```
    def scale(amount : Number) : CommonMatrix
      map &.*(amount)
    end

    # Scales each element by the specified amount.
    #
    # Values will wrap instead of overflowing and raising an error.
    #
    # ```
    # Matrix[[5, -2], [0, 1]].scale!(3) # => [[15, -6], [0, 3]]
    # ```
    def scale!(amount : Number) : CommonMatrix
      map &.&*(amount)
    end

    # Calculates the linear interpolation between two matrices.
    #
    # *t* is a value from 0 to 1, where 0 represents this matrix and 1 represents *other*.
    # Any value between 0 and 1 will result in a proportional amount of this matrix and *other*.
    #
    # This method uses the precise calculation
    # that does not suffer precision loss from high exponential differences.
    def lerp(other : CommonMatrix(T, M, N), t : Number) : CommonMatrix forall T
      Geode.lerp(self, other, t)
    end

    # Returns a negated matrix.
    #
    # ```
    # -Matrix[[5, -2], [0, 1]] # => [[-5, 2], [0, -1]]
    # ```
    def - : self
      map &.-
    end

    # Adds two matrices together.
    #
    # ```
    # Matrix[[5, -2], [0, 1]] + Matrix[[2, -1], [4, -2]] # => [[7, -3], [4, -1]]
    # ```
    def +(other : CommonMatrix(T, M, N)) : CommonMatrix forall T
      zip_map(other) { |a, b| a + b }
    end

    # Adds two matrices together.
    #
    # Values will wrap instead of overflowing and raising an error.
    #
    # ```
    # Matrix[[5, -2], [0, 1]] &+ Matrix[[2, -1], [4, -2]] # => [[7, -3], [4, -1]]
    # ```
    def &+(other : CommonMatrix(T, M, N)) : CommonMatrix forall T
      zip_map(other) { |a, b| a &+ b }
    end

    # Subtracts another matrix from this one.
    #
    # ```
    # Matrix[[5, -2], [0, 1]] - Matrix[[2, -1], [4, -2]] # => [[3, -1], [-4, 3]]
    # ```
    def -(other : CommonMatrix(T, M, N)) : CommonMatrix forall T
      zip_map(other) { |a, b| a - b }
    end

    # Subtracts another matrix from this one.
    #
    # Values will wrap instead of overflowing and raising an error.
    #
    # ```
    # Matrix[[5, -2], [0, 1]] &- Matrix[[2, -1], [4, -2]] # => [[3, -1], [-4, 3]]
    # ```
    def &-(other : CommonMatrix(T, M, N)) : CommonMatrix forall T
      zip_map(other) { |a, b| a &- b }
    end

    # Scales each element by the specified amount.
    #
    # ```
    # Matrix[[5, -2], [0, 1]] * 3 # => [[15, -6], [0, 3]]
    # ```
    def *(scalar : Number) : CommonMatrix
      map &.*(scalar)
    end

    # Scales each element by the specified amount.
    #
    # Values will wrap instead of overflowing and raising an error.
    #
    # ```
    # Matrix[[5, -2], [0, 1]] &* 3 # => [[15, -6], [0, 3]]
    # ```
    def &*(scalar : Number) : CommonMatrix
      map &.&*(scalar)
    end

    # Scales each element by the specified amount.
    #
    # ```
    # Matrix[[16, -2], [0, 1]] / 4 # => [[4.0, -0.5], [0.0, 0.25]]
    # ```
    def /(scalar : Number) : CommonMatrix
      map &./(scalar)
    end

    # Scales each element by the specified amount.
    #
    # Uses integer division.
    #
    # ```
    # Matrix[[7, -3], [0, 1]] // 3 # => [[2, -1], [0, 0]]
    # ```
    def //(scalar : Number) : CommonMatrix
      map &.//(scalar)
    end
  end
end
