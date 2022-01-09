module Geode
  # Comparison operations for matrices.
  #
  # Intended to be used as a mix-in on matrix types.
  # *M* and *N* are positive integers indicating the number of rows and columns respectively.
  module MatrixComparison(M, N)
    # Compares elements of this matrix to another.
    #
    # Each element of the resulting matrix is an integer.
    # The value will be:
    # - -1 if the element from this matrix is less than the corresponding element from *other*.
    # - 0 if the element from this matrix is equal to the corresponding element from *other*.
    # - 1 if the element from this matrix is greater than the corresponding element from *other*.
    # - nil if the elements can't be compared.
    #
    # ```
    # Matrix[[0, 1], [2, 3]].compare(Matrix[[0, 3, 2, 1]]) # => [[0, -1], [0, 1]]
    # ```
    def compare(other : CommonMatrix(T, M, N)) : CommonMatrix(Int32, M, N) forall T
      zip_map(other) { |a, b| a <=> b }
    end

    # Checks if elements between two matrices are equal.
    #
    # Compares this matrix element-wise to another.
    # Returns a bool matrix.
    # Elements of the resulting matrix are true
    # if the corresponding matrix elements were equal.
    #
    # ```
    # Matrix[[0, 1], [2, 3]].eq?(Matrix[[0, 3], [2, 1]]) # => [[true, false], [true, false]]
    # ```
    def eq?(other : CommonMatrix(T, M, N)) : CommonMatrix(Bool, M, N) forall T
      zip_map(other) { |a, b| a == b }
    end

    # Checks if elements of this matrix are less than those from another matrix.
    #
    # Compares this matrix element-wise to another.
    # Returns a bool matrix.
    # Elements of the resulting matrix are true
    # if the corresponding element from this matrix is less than the element from *other*.
    #
    # ```
    # Matrix[[0, 1], [2, 3]].lt?(Matrix[[0, 3], [2, 1]]) # => [[false, true], [false, false]]
    # ```
    def lt?(other : CommonMatrix(T, M, N)) : CommonMatrix(Bool, M, N) forall T
      zip_map(other) { |a, b| a < b }
    end

    # Checks if elements of this matrix are less than or equal to those from another matrix.
    #
    # Compares this matrix element-wise to another.
    # Returns a bool matrix.
    # Elements of the resulting matrix are true
    # if the corresponding element from this matrix is less than or equal to the element from *other*.
    #
    # ```
    # Matrix[[0, 1], [2, 3]].le?(Matrix[[0, 3], [2, 1]]) # => [[true, true], [true, false]]
    # ```
    def le?(other : CommonMatrix(T, M, N)) : CommonMatrix(Bool, M, N) forall T
      zip_map(other) { |a, b| a <= b }
    end

    # Checks if elements of this matrix are greater than those from another matrix.
    #
    # Compares this matrix element-wise to another.
    # Returns a bool matrix.
    # Elements of the resulting matrix are true
    # if the corresponding element from this matrix is greater than the element from *other*.
    #
    # ```
    # Matrix[[0, 1], [2, 3]].gt?(Matrix[[0, 3], [2, 1]]) # => [[false, false], [false, true]]
    # ```
    def gt?(other : CommonMatrix(T, M, N)) : CommonMatrix(Bool, M, N) forall T
      zip_map(other) { |a, b| a > b }
    end

    # Checks if elements of this matrix are greater than or equal to those from another matrix.
    #
    # Compares this matrix element-wise to another.
    # Returns a bool matrix.
    # Elements of the resulting matrix are true
    # if the corresponding element from this matrix is greater than or equal to the element from *other*.
    #
    # ```
    # Matrix[[0, 1], [2, 3]].ge?(Matrix[[0, 3], [2, 1]]) # => [[false, true], [true, true]]
    # ```
    def ge?(other : CommonMatrix(T, M, N)) : CommonMatrix(Bool, M, N) forall T
      zip_map(other) { |a, b| a >= b }
    end

    # Checks if this is a zero-matrix.
    #
    # Returns true if all elements of the matrix are zero.
    #
    # See: `#near_zero?`
    #
    # ```
    # Matrix[[0, 0], [0, 0]].zero? # => true
    # Matrix[[0, 1], [1, 0]].zero? # => false
    # ```
    def zero?
      all? &.zero?
    end

    # Checks if this is close to a zero-matrix.
    #
    # Returns true if all elements of the matrix are close to zero.
    #
    # ```
    # Matrix[[0.0, 0.01], [0.001, 0.0001]].near_zero?(0.01) # => true
    # Matrix[[0.1, 0.0], [0.01, 1.0]].near_zero?(0.01)      # => false
    # ```
    def near_zero?(tolerance)
      all? { |v| v.abs <= tolerance }
    end

    # Checks if elements between two matrices are equal.
    #
    # Compares this matrix element-wise to another.
    # Returns true if all elements are equal, false otherwise.
    #
    # ```
    # Matrix[[1, 2], [3, 4], [5, 6]] == Matrix3x2[[1, 2], [3, 4], [5, 6]]) # => true
    # Matrix[[1, 2], [3, 4]] == Matrix2[[4, 3], [2, 1]]                    # => false
    # ```
    def ==(other : CommonMatrix(T, M, N)) forall T
      # This check shouldn't be needed, but the M and N type parameters don't seem to be enforced in all cases.
      # For instance: `Geode::Matrix3x2(Int32) == Geode::Matrix(Int32, 3, 2)`
      return false if rows != other.rows || columns != other.columns

      each_with_index do |element, index|
        return false if element != other.unsafe_fetch(index)
      end
      true
    end
  end
end
