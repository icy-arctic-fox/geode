require "../vectors/common"
require "./comparison"
require "./operations"
require "./vectors"

module Geode
  # Common functionality across all matrix types.
  #
  # This type primarily serves as a means to unify `MatrixMxN(T)` and `Matrix(T, M, N)` types.
  #
  # There are two indexing schemes for matrices.
  # The first is two-dimension indexing, which is standard for matrix operations.
  # It takes two indices - *i* and *j*.
  # *i* refers to the row index and ranges from 0 to M - 1.
  # *j* refers to the column index and ranges from 0 to N - 1.
  # Methods with *indices* in the name use this indexing scheme.
  #
  # The second is flat, one-dimension indexing.
  # It takes a single index and ranges from 0 to (M * N) - 1.
  # Standard Crystal library types such as `Indexable` use this indexing scheme.
  # To avoid confusion, this module specifies the flat index as *index* instead of *i*.
  #
  # Unless noted otherwise, all operations are in row-major order.
  module CommonMatrix(T, M, N)
    include Indexable(T)
    include MatrixComparison(M, N)
    include MatrixOperations(M, N)
    include MatrixVectors(M, N)

    # Ensures that another matrix and this one have the same size at compile-time.
    #
    # The *rows* and *columns* arguments should be the type arguments from the other matrix type.
    #
    # ```
    # def something(other : CommonMatrix(T, M, N))
    #   same_size!(M, N)
    #   # ...
    # end
    # ```
    private macro same_size!(rows, columns)
      \{% raise "Matrices must have the same dimensions for this operation (#{{{rows}}}x#{{{columns}}} != #{@type.type_vars[1]}x#{@type.type_vars[2]})" if {{rows}} != @type.type_vars[1] || {{columns}} != @type.type_vars[2] %}
    end

    # Returns the number of rows in this matrix.
    #
    # Is always equal to the type argument *M*.
    def rows : Int
      M
    end

    # Returns the number of columns in this matrix.
    #
    # Is always equal to the type argument *N*.
    def columns : Int
      N
    end

    # Returns the number of elements in this matrix.
    def size
      M * N
    end

    # Checks if this matrix is square.
    #
    # Returns true if *M* equals *N*.
    def square?
      M == N
    end

    # Enumerates through each of the indices (not the elements).
    #
    # Yields for each index combination in the matrix.
    # Two arguments are supplied to the block: *i* and *j*.
    #
    # ```
    # Matrix[[0, 1], [2, 3]].each_indices do |i, j|
    #   puts "#{i}, #{j}"
    # end
    #
    # # Output:
    # # 0, 0
    # # 0, 1
    # # 1, 0
    # # 1, 1
    # ```
    def each_indices(& : Int32, Int32 -> _)
      M.times do |i|
        N.times do |j|
          yield i, j
        end
      end
    end

    # Enumerates through each element and its indices.
    #
    # Yields for each element in the matrix.
    # Three arguments are supplied to the block: the element, *i*, and *j*.
    #
    # ```
    # Matrix[[0, 1], [2, 3]].each_with_indices do |e, i, j|
    #   puts "#{i}, #{j}: #{e}"
    # end
    #
    # # Output:
    # # 0, 0: 0
    # # 0, 1: 1
    # # 1, 0: 2
    # # 1, 1: 3
    # ```
    def each_with_indices(& : T, Int32, Int32 -> _)
      index = 0
      each_indices do |i, j|
        element = unsafe_fetch(index)
        index += 1
        yield element, i, j
      end
    end

    # Returns a new matrix where elements are mapped by the given block.
    #
    # ```
    # matrix = Matrix[[1, 2], [3, 4]]
    # matrix.map { |e| e * 2 } # => [[2, 4], [6, 8]]
    # ```
    abstract def map(& : T -> U) : CommonMatrix forall U

    # Like `#map`, but the block gets the elements and its flat index as arguments.
    #
    # Accepts an optional *offset* parameter, which to start the index at.
    #
    # ```
    # matrix = Matrix[[1, 2], [3, 4]]
    # matrix.map_with_index { |e, i| e * i }    # => [[0, 2], [6, 12]]
    # matrix.map_with_index(3) { |e, i| e + i } # => [[4, 6], [8, 10]]
    # ```
    def map_with_index(offset = 0, & : T, Int32 -> U) : CommonMatrix forall U
      index = offset
      map do |element|
        value = yield element, index
        index += 1
        value
      end
    end

    # Like `#map`, but the block gets the elements and its indices as arguments.
    #
    # ```
    # matrix = Matrix[[1, 2], [3, 4]]
    # matrix.map_with_indices { |e, i, j| e * i + j } # => [[0, 1], [3, 5]]
    # ```
    def map_with_indices(& : T, Int32, Int32 -> U) : CommonMatrix forall U
      i = 0
      j = 0

      map do |element|
        value = yield element, i, j

        j += 1
        if j >= N
          j = 0
          i += 1
        end

        value
      end
    end

    # Returns a new matrix by iterating through each element of this matrix and another.
    #
    # ```
    # m1 = Matrix[[1, 2], [3, 4]]
    # m2 = Matrix[[4, 3], [2, 1]]
    # m1.zip_map { |a, b| Math.min(a, b) } # => [[1, 2], [2, 1]]
    # ```
    def zip_map(other : CommonMatrix(U, M, N), & : T, U -> V) : CommonMatrix forall U, V
      same_size!(M, N)

      map_with_index do |element, index|
        value = other.unsafe_fetch(index)
        yield element, value
      end
    end

    # Enumerates through each row of the matrix.
    #
    # Yields a vector with the elements from the current row.
    # The size of the vector is equal to the number of columns.
    #
    # ```
    # Matrix[[1, 2, 3], [4, 5, 6]].each_row do |row|
    #   puts row
    # end
    #
    # # Output:
    # # (1, 2, 3)
    # # (4, 5, 6)
    # ```
    def each_row(& : CommonVector(T, N) -> _)
      M.times do |i|
        yield unsafe_fetch_row(i)
      end
    end

    # Enumerates through each row of the matrix.
    #
    # Yields a vector with the elements from the current row and the row index.
    # The size of the vector is equal to the number of columns.
    # An *offset* can be specified, which is added to the yielded row index.
    # This does not affect the starting row.
    #
    # ```
    # Matrix[[1, 2, 3], [4, 5, 6]].each_row_with_index(1) do |row, i|
    #   puts "#{i}: #{row}"
    # end
    #
    # # Output:
    # # 1: (1, 2, 3)
    # # 2: (4, 5, 6)
    # ```
    def each_row_with_index(offset = 0, & : CommonVector(T, N), Int32 -> _)
      M.times do |i|
        yield unsafe_fetch_row(i), offset + i
      end
    end

    # Enumerates through each column of the matrix.
    #
    # Yields a vector with the elements from the current column.
    # The size of the vector is equal to the number of rows.
    #
    # ```
    # Matrix[[1, 2, 3], [4, 5, 6]].each_column do |column|
    #   puts column
    # end
    #
    # # Output:
    # # (1, 4)
    # # (2, 5)
    # # (3, 6)
    # ```
    def each_column(& : CommonVector(T, M) -> _)
      N.times do |j|
        yield unsafe_fetch_column(j)
      end
    end

    # Enumerates through each column of the matrix.
    #
    # Yields a vector with the elements from the current column and the column index.
    # The size of the vector is equal to the number of rows.
    # An *offset* can be specified, which is added to the yielded column index.
    # This does not affect the starting column.
    #
    # ```
    # Matrix[[1, 2, 3], [4, 5, 6]].each_column_with_index(1) do |column, j|
    #   puts "#{j}: #{column}"
    # end
    #
    # # Output:
    # # 1: (1, 4)
    # # 2: (2, 5)
    # # 3: (3, 6)
    # ```
    def each_column_with_index(offset = 0, & : CommonVector(T, M), Int32 -> _)
      N.times do |j|
        yield unsafe_fetch_column(j), offset + j
      end
    end

    # Retrieves the element at the specified indices.
    #
    # Raises an `IndexError` if the indices are outside the bounds of the matrix.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6]]
    # matrix[1, 2] # => 6
    # matrix[3, 3] # IndexError
    # ```
    def [](i : Int, j : Int) : T
      self[i, j]? || raise IndexError.new
    end

    # Retrieves the element at the specified indices.
    #
    # Returns nil if the indices are outside the bounds of the matrix.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6]]
    # matrix[1, 2]? # => 6
    # matrix[3, 3]? # => nil
    # ```
    def []?(i : Int, j : Int) : T?
      return unless index = flat_index?(i, j)

      unsafe_fetch(index)
    end

    # Retrieves the row at the specified index.
    #
    # Returns the elements as a vector.
    # The vector will have a size equal to the number of columns in this matrix.
    # If the row *i* is out of range, an `IndexError` is raised.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6]]
    # matrix.row(1) # => (4, 5, 6)
    # matrix.row(2) # IndexError
    # ```
    def row(i : Int) : CommonVector(T, N)
      row?(i) || raise IndexError.new
    end

    # Retrieves the row at the specified index.
    #
    # Returns the elements as a vector.
    # The vector will have a size equal to the number of columns in this matrix.
    # If the row *i* is out of range, nil is returned.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6]]
    # matrix.row?(1) # => (4, 5, 6)
    # matrix.row?(2) # => nil
    # ```
    def row?(i : Int) : CommonVector(T, N)?
      return unless 0 <= i < M

      unsafe_fetch_row(i)
    end

    # Retrieves the row at the specified index.
    #
    # Returns the elements as a vector.
    # The vector will have a size equal to the number of columns in this matrix.
    # This method does not perform any bounds checks.
    # It should only be used if the indices are guaranteed to be in bounds.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6]]
    # matrix.unsafe_fetch_row(1) # => (4, 5, 6)
    # ```
    def unsafe_fetch_row(i : Int) : CommonVector(T, N)
      Vector(T, N).new do |j|
        unsafe_fetch(i, j)
      end
    end

    # Retrieves the column at the specified index.
    #
    # Returns the elements as a vector.
    # The vector will have a size equal to the number of rows in this matrix.
    # If the column *j* is out of range, an `IndexError` is raised.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6]]
    # matrix.column(1) # => (2, 5)
    # matrix.column(3) # IndexError
    # ```
    def column(j : Int) : CommonVector(T, M)
      column?(j) || raise IndexError.new
    end

    # Retrieves the column at the specified index.
    #
    # Returns the elements as a vector.
    # The vector will have a size equal to the number of rows in this matrix.
    # If the column *j* is out of range, nil is returned.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6]]
    # matrix.column?(1) # => (2, 5)
    # matrix.column?(3) # => nil
    # ```
    def column?(j : Int) : CommonVector(T, M)?
      return unless 0 <= j < N

      unsafe_fetch_column(j)
    end

    # Retrieves the column at the specified index.
    #
    # Returns the elements as a vector.
    # The vector will have a size equal to the number of rows in this matrix.
    # This method does not perform any bounds checks.
    # It should only be used if the indices are guaranteed to be in bounds.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6]]
    # matrix.unsafe_fetch_column(1) # => (2, 5)
    # ```
    def unsafe_fetch_column(j : Int) : CommonVector(T, M)
      Vector(T, M).new do |i|
        unsafe_fetch(i, j)
      end
    end

    # Retrieves the scalar value of the component at the given indices,
    # without checking size boundaries.
    #
    # End-users should never invoke this method directly.
    # Instead, methods like `#[]` and `#[]?` should be used.
    #
    # This method should only be directly invoked if *i* and *j* are certain to be in bounds.
    def unsafe_fetch(i : Int, j : Int) : T
      index = flat_index(i, j)
      unsafe_fetch(index)
    end

    # Retrieves multiple rows at the specified indices.
    #
    # Returns the rows as vectors in a tuple.
    # Each vector will have a size equal to the number of columns in this matrix.
    # If a row index (*i*) from *indices* is out of range, an IndexError is raised.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    # matrix.rows_at(1, 2) # => {(4, 5, 6), (7, 8, 9)}
    # matrix.rows_at(3)    # IndexError
    # ```
    def rows_at(*indices) : Tuple
      indices.map { |i| row(i) }
    end

    # Retrieves multiple columns at the specified indices.
    #
    # Returns the columns as vectors in a tuple.
    # Each vector will have a size equal to the number of rows in this matrix.
    # If a column index (*j*) from *indices* is out of range, an IndexError is raised.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    # matrix.columns_at(1, 2) # => {(2, 5, 8), (3, 6, 9)}
    # matrix.columns_at(3)    # IndexError
    # ```
    def columns_at(*indices) : Tuple
      indices.map { |j| column(j) }
    end

    # Converts the matrix to an array of rows.
    #
    # Each element in the array is a row vector.
    # The vectors will have a size equal to the number of columns in this matrix.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    # matrix.to_rows # => [(1, 2, 3), (4, 5, 6), (7, 8, 9)]
    # ```
    def to_rows : Array(Vector(T, N))
      Array.new(M) do |i|
        unsafe_fetch_row(i)
      end
    end

    # Converts the matrix to an array of columns.
    #
    # Each element in the array is a column vector.
    # The vectors will have a size equal to the number of rows in this matrix.
    #
    # ```
    # matrix = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    # matrix.to_columns # => [(1, 4, 7), (2, 5, 8), (3, 6, 9)]
    # ```
    def to_columns : Array(Vector(T, M))
      Array.new(N) do |j|
        unsafe_fetch_column(j)
      end
    end

    # Produces a string representation of the matrix.
    #
    # The format is: `[[a_00, a_01], [a_10, a_11]]`
    # but with the corresponding number of elements.
    def to_s(io : IO) : Nil
      io << '['

      i = 0
      j = 0

      each do |element|
        io << '[' if j == 0
        io << element

        j += 1
        if j >= N
          j = 0
          i += 1
          io << ']'
          io << ", " if i < M
        else
          io << ", "
        end
      end

      io << ']'
    end

    # Produces a debugger-friendly string representation of the matrix.
    def inspect(io : IO) : Nil
      io << self.class
      io << "#<"
      join(io, ", ")
      io << '>'
    end

    # Checks if the two-dimensional indices are in range.
    @[AlwaysInline]
    private def in_range?(i, j)
      0 <= i < M && 0 <= j < N
    end

    # Converts two-dimension matrix indices to a flat index.
    @[AlwaysInline]
    private def flat_index(i, j)
      i * N + j
    end

    # Converts two-dimension matrix indices to a flat index.
    #
    # Returns nil if the indices are out of range.
    @[AlwaysInline]
    private def flat_index?(i, j)
      flat_index(i, j) if in_range?(i, j)
    end
  end
end
