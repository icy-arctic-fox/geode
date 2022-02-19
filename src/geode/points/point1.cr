require "./point"

module Geode
  # One dimensional point.
  #
  # Using this type generally doesn't make sense,
  # but it is included to complete some rules and combinations.
  #
  # *T* is the scalar type.
  struct Point1(T) < Point(T, 1)
    # Constructs a point with existing coordinates.
    #
    # The type of the coordinates is derived from the type of each argument.
    #
    # ```
    # Point1[1] # => (1)
    # ```
    def self.[](x : T)
      new(x)
    end

    # Constructs a point with existing coordinates.
    #
    # The type of the coordinates is specified by the type parameter.
    # Each value is cast to the type *T*.
    #
    # ```
    # Point1F[1] # => (1.0)
    # ```
    def self.[](x)
      new(T.new(x))
    end

    # Creates a point from its coordinates.
    def initialize(x : T)
      array = uninitialized T[1]
      array[0] = x
      initialize(array)
    end

    # Constructs the point by yielding for each coordinate.
    #
    # The value of each coordinate should be returned from the block.
    # The block will be given the index of each coordinate as an argument.
    #
    # ```
    # Point1(Int32).new { |i| i + 5 } # => (5)
    # ```
    def initialize(& : Int32 -> T)
      super { |i| yield i }
    end

    # Retrieves the x-coordinate.
    def x : T
      unsafe_fetch(0)
    end

    # Converts this point to a vector.
    #
    # ```
    # point = Point1[5]
    # point.to_vector # => (5)
    # ```
    def to_vector
      Vector1(T).new(@array)
    end

    # Retrieves the coordinates as a tuple.
    def tuple : Tuple(T)
      {x}
    end

    # Converts this point to a row vector,
    # in other words a matrix with one row.
    #
    # ```
    # point = Point1[5]
    # point.to_row # => [[5]]
    # ```
    def to_row : Matrix1x1(T)
      Matrix1x1.new(@array)
    end

    # Converts this point to a column vector,
    # in other words a matrix with one column.
    #
    # ```
    # point = Point1[5]
    # point.to_column # => [[5]]
    # ```
    def to_column : Matrix1x1(T)
      Matrix1x1.new(@array)
    end

    # Produces a debugger-friendly string representation of the point.
    def inspect(io : IO) : Nil
      io << self.class << "#<x: " << x << '>'
    end
  end

  # A one-dimensional point.
  # Contains an x-coordinate.
  # The coordinate is a 32-bit integer.
  alias Point1I = Point1(Int32)

  # A one-dimensional point.
  # Contains an x-coordinate.
  # The coordinate is a 64-bit integer.
  alias Point1L = Point1(Int64)

  # A one-dimensional point.
  # Contains an x-coordinate.
  # The coordinate is a 32-bit floating-point number.
  alias Point1F = Point1(Float32)

  # A one-dimensional point.
  # Contains an x-coordinate.
  # The coordinate is a 64-bit floating-point number.
  alias Point1D = Point1(Float64)
end
