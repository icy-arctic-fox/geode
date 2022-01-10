module Geode
  # Operations applicable to square matrices.
  #
  # Intended to be used as a mix-in on matrix types.
  # *M* and *N* are positive integers indicating the number of rows and columns respectively.
  # These methods will produce a compilation error when called on a non-square matrix.
  module SquareMatrix(T, M, N)
    # Retrieves the elements of the main diagonal.
    #
    # Returns the elements as a vector.
    #
    # This method can only be called on square matrices.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    # matrix.diagonal # => (1, 5, 9)
    # ```
    def diagonal : CommonVector(T, N)
      square!(M, N)

      Vector(T, N).new do |i|
        unsafe_fetch(i, i)
      end
    end

    # Enumerates through the elements of the main diagonal.
    #
    # This method can only be called on square matrices.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    # matrix.each_diagonal do |e|
    #   puts e
    # end
    #
    # # Output:
    # # 1
    # # 5
    # # 9
    # ```
    def each_diagonal(& : T -> _) : Nil
      square!(M, N)

      index = 0
      N.times do |i|
        yield unsafe_fetch(index)
        index += M + 1
      end
    end

    # Returns an iterator that enumerates through the elements of the main diagonal.
    #
    # This method can only be called on square matrices.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    # matrix.each_diagonal.to_a # => [1, 5, 9]
    # ```
    def each_diagonal
      square!(M, N)

      diagonal.each
    end

    # Computes the trace of the matrix.
    #
    # The trace is the sum of the elements along the main diagonal.
    #
    # This method can only be called on square matrices.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    # matrix.trace # => 15
    # ```
    def trace
      square!(M, N)

      sum = T.zero
      each_diagonal do |e|
        sum += e
      end
      sum
    end

    # Computes the determinant of this matrix.
    #
    # This method can only be called on square matrices.
    #
    # ```
    # matrix = Matrix[[1, 4, 7], [5, 8, 2], [9, 3, 6]]
    # matrix.determinant # => -405
    # ```
    def determinant
      square!(M, N)

      raise NotImplementedError.new("#determinant")
    end

    # Ensures that this matrix is square (equal rows and columns).
    #
    # The *rows* and *columns* arguments should be the corresponding type arguments from this matrix trype.
    #
    # ```
    # def something
    #   square!(M, N)
    #   # ...
    # end
    # ```
    private macro square!(rows, columns)
      \{% raise "#{@def.name} can only be called on square matrices (matrix is #{{{rows}}}x#{{{columns}}})" if {{rows}} != {{columns}} %}
    end
  end
end
