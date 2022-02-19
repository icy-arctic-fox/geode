require "./point"

module Geode
  # Two dimensional point.
  #
  # *T* is the scalar type.
  struct Point2(T) < Point(T, 2)
    # Constructs a point with existing coordinates.
    #
    # The type of the coordinates is derived from the type of each argument.
    #
    # ```
    # Point2[1, 2] # => (1, 2)
    # ```
    def self.[](x : T, y : T)
      new(x, y)
    end

    # Constructs a point with existing coordinates.
    #
    # The type of the coordinates is specified by the type parameter.
    # Each value is cast to the type *T*.
    #
    # ```
    # Point2F[1, 2] # => (1.0, 2.0)
    # ```
    def self.[](x, y)
      new(T.new(x), T.new(y))
    end

    # Creates a point from its coordinates.
    def initialize(x : T, y : T)
      array = uninitialized T[2]
      array[0] = x
      array[1] = y
      initialize(array)
    end

    # Constructs the point by yielding for each coordinate.
    #
    # The value of each coordinate should be returned from the block.
    # The block will be given the index of each coordinate as an argument.
    #
    # ```
    # Point2(Int32).new { |i| i + 5 } # => (5, 6)
    # ```
    def initialize(& : Int32 -> T)
      super { |i| yield i }
    end

    # Retrieves the x-coordinate.
    def x : T
      unsafe_fetch(0)
    end

    # Retrieves the y-coordinate.
    def y : T
      unsafe_fetch(1)
    end

    # Converts this point to a vector.
    #
    # ```
    # point = Point2[5, 7]
    # point.to_vector # => (5, 7)
    # ```
    def to_vector
      Vector2(T).new(@array)
    end

    # Retrieves the coordinates as a tuple.
    def tuple : Tuple(T, T)
      {x, y}
    end

    # Converts this point to a row vector,
    # in other words a matrix with one row.
    #
    # ```
    # point = Point2[5, 7]
    # point.to_row # => [[5, 7]]
    # ```
    def to_row : Matrix1x2(T)
      Matrix1x2.new(@array)
    end

    # Converts this point to a column vector,
    # in other words a matrix with one column.
    #
    # ```
    # point = Point2[5, 7]
    # point.to_column # => [[5], [7]]
    # ```
    def to_column : Matrix2x1(T)
      Matrix2x1.new(@array)
    end

    # Produces a debugger-friendly string representation of the point.
    def inspect(io : IO) : Nil
      io << self.class << "#<x: " << x << ", y: " << y << '>'
    end
  end

  # A two-dimensional point.
  # Contains x and y-coordinates.
  # The coordinates are 32-bit integers.
  alias Point2I = Point2(Int32)

  # A two-dimensional point.
  # Contains x and y-coordinates.
  # The coordinates are a 64-bit integers.
  alias Point2L = Point2(Int64)

  # A two-dimensional point.
  # Contains x and y-coordinates.
  # The coordinates are a 32-bit floating-point numbers.
  alias Point2F = Point2(Float32)

  # A two-dimensional point.
  # Contains x and y-coordinates.
  # The coordinates are a 64-bit floating-point numbers.
  alias Point2D = Point2(Float64)
end
