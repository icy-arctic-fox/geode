require "../vectors/common"

module Geode
  # Methods for matrices interacting with vectors.
  #
  # Intended to be used as a mix-in on matrix types.
  # *M* and *N* are the number of rows and columns respectively.
  module MatrixVectors(M, N)
    # Indicates whether this matrix is a row vector.
    #
    # Returns true if the matrix has one row.
    def row?
      M == 1
    end

    # Indicates whether this matrix is a column vector.
    #
    # Returns true if the matrix has one column.
    def column?
      N == 1
    end

    # Converts this matrix to a vector.
    #
    # Requires that the matrix is a row or column vector.
    # That is, the matrix has one row or one column.
    #
    # ```
    # matrix = Matrix[[1, 2, 3]]
    # matrix.to_vector # => (1, 2, 3)
    # matrix = Matrix[[1], [2], [3]]
    # matrix.to_vector # => (1, 2, 3)
    # ```
    def to_vector : CommonVector
      {% if M == 1 %}
        unsafe_fetch_row(0)
      {% elsif N == 1 %}
        unsafe_fetch_column(0)
      {% else %}
        {% raise "#to_vector can only be called on matrices with one row or one column" %}
      {% end %}
    end

    # Multiplies the matrix by a vector.
    #
    # The vector is treated as a single column matrix.
    # Returns a vector of equal size.
    # This method requires that the matrix is square (M == N)
    # and the size of the vector matches the side length of this matrix.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    # vector = Vector[1, 10, 100]
    # matrix * vector # => (321, 654, 987)
    # ```
    def *(vector : CommonVector(U, P)) : CommonVector forall U, P
      {% raise "Vector length must equal matrix side length for this operation (#{M}x#{N} != #{P})" if N != M || N != P %}

      vector.map_with_index do |_, index|
        row = unsafe_fetch_row(index)
        vector.zip_map(row) do |v, e|
          e * v
        end.sum
      end
    end

    # Multiplies the matrix by a vector.
    #
    # The vector is treated as a single column matrix.
    # Returns a vector of equal size.
    # This method requires that the matrix is square (M == N)
    # and the size of the vector matches the side length of this matrix.
    #
    # Values will wrap instead of overflowing and raising an error.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    # vector = Vector[1, 10, 100]
    # matrix &* vector # => (321, 654, 987)
    # ```
    def &*(vector : CommonVector(U, P)) : CommonVector forall U, P
      {% raise "Vector length must equal matrix side length for this operation (#{M}x#{N} != #{P})" if N != M || N != P %}

      vector.map_with_index do |_, index|
        row = unsafe_fetch_row(index)
        sum = U.zero
        vector.each_index do |i|
          sum &+= row.unsafe_fetch(i) &* vector.unsafe_fetch(i)
        end
        sum
      end
    end
  end
end
