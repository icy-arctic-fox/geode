require "../matrices/common"

module Geode
  # Methods for vectors interacting with matrices.
  #
  # Intended to be used as a mix-in on vector types.
  # *N* is the number of components in the vector.
  module VectorMatrices(T, N)
    # Converts this vector to a row vector,
    # in other words a matrix with one row.
    #
    # ```
    # vector = Vector[1, 2, 3]
    # vector.to_row # => [[1, 2, 3]]
    # ```
    def to_row : CommonMatrix
      Matrix(T, 1, N).new(to_unsafe)
    end

    # Converts this vector to a column vector,
    # in other words a matrix with one column.
    #
    # ```
    # vector = Vector[1, 2, 3]
    # vector.to_column # => [[1], [2], [3]]
    # ```
    def to_column : CommonMatrix
      Matrix(T, N, 1).new(to_unsafe)
    end

    # Multiplies the vector by a matrix.
    #
    # The vector is treated as a single row matrix.
    # Returns a vector of equal size.
    # This method requires that the matrix is square (M == N)
    # and the size of the vector matches the side length of this matrix.
    #
    # ```
    # vector = Vector[1, 10, 100]
    # matrix = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    # vector * matrix # => (741, 852, 963)
    # ```
    def *(matrix : CommonMatrix(U, M, M)) : CommonVector forall U, M
      {% raise "Vector length must equal matrix side length for this operation (#{M}x#{M} != #{N})" if N != M %}

      map_with_index do |_, index|
        column = matrix.unsafe_fetch_column(index)
        zip_map(column) do |v, e|
          e * v
        end.sum
      end
    end

    # Multiplies the vector by a matrix.
    #
    # The vector is treated as a single row matrix.
    # Returns a vector of equal size.
    # This method requires that the matrix is square (M == N)
    # and the size of the vector matches the side length of this matrix.
    #
    # Values will wrap instead of overflowing and raising an error.
    #
    # ```
    # vector = Vector[1, 10, 100]
    # matrix = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    # vector &* matrix # => (741, 852, 963)
    # ```
    def &*(matrix : CommonMatrix(U, M, M)) : CommonVector forall U, M
      {% raise "Vector length must equal matrix side length for this operation (#{M}x#{M} != #{N})" if N != M %}

      map_with_index do |_, index|
        column = matrix.unsafe_fetch_column(index)
        sum = U.zero
        each_index do |i|
          sum &+= unsafe_fetch(i) &* column.unsafe_fetch(i)
        end
        sum
      end
    end
  end
end
