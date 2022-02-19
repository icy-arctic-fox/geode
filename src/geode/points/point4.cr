require "./point"

module Geode
  # Four dimensional point.
  #
  # *T* is the scalar type.
  struct Point4(T) < Point(T, 4)
    # Constructs a point with existing coordinates.
    #
    # The type of the coordinates is derived from the type of each argument.
    #
    # ```
    # Point4[1, 2, 3, 4] # => (1, 2, 3, 4)
    # ```
    def self.[](x : T, y : T, z : T, w : T)
      new(x, y, z, w)
    end

    # Constructs a point with existing coordinates.
    #
    # The type of the coordinates is specified by the type parameter.
    # Each value is cast to the type *T*.
    #
    # ```
    # Point4F[1, 2, 3, 4] # => (1.0, 2.0, 3.0, 4.0)
    # ```
    def self.[](x, y, z, w)
      new(T.new(x), T.new(y), T.new(z), T.new(w))
    end

    # Creates a point from its coordinates.
    def initialize(x : T, y : T, z : T, w : T)
      array = uninitialized T[4]
      array[0] = x
      array[1] = y
      array[2] = z
      array[3] = w
      initialize(array)
    end

    # Constructs the point by yielding for each coordinate.
    #
    # The value of each coordinate should be returned from the block.
    # The block will be given the index of each coordinate as an argument.
    #
    # ```
    # Point4(Int32).new { |i| i + 5 } # => (5, 6, 7, 8)
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

    # Retrieves the z-coordinate.
    def z : T
      unsafe_fetch(2)
    end

    # Retrieves the w-coordinate.
    def w : T
      unsafe_fetch(3)
    end

    # Converts this point to a vector.
    #
    # ```
    # point = Point4[3, 5, 7, 9]
    # point.to_vector # => (3, 5, 7, 9)
    # ```
    def to_vector
      Vector4(T).new(@array)
    end

    # Retrieves the coordinates as a tuple.
    def tuple : Tuple(T, T, T, T)
      {x, y, z, w}
    end

    # Converts this point to a row vector,
    # in other words a matrix with one row.
    #
    # ```
    # point = Point4[3, 5, 7, 9]
    # point.to_row # => [[3, 5, 7, 9]]
    # ```
    def to_row : Matrix1x4(T)
      Matrix1x4.new(@array)
    end

    # Converts this point to a column vector,
    # in other words a matrix with one column.
    #
    # ```
    # point = Point4[3, 5, 7, 9]
    # point.to_column # => [[3], [5], [7], [9]]
    # ```
    def to_column : Matrix4x1(T)
      Matrix4x1.new(@array)
    end

    # Produces a debugger-friendly string representation of the point.
    def inspect(io : IO) : Nil
      io << self.class << "#<x: " << x << ", y: " << y << ", z: " << z << ", w: " << w << '>'
    end
  end

  # A four-dimensional point.
  # Contains x, y, z, and w-coordinates.
  # The coordinates are 32-bit integers.
  alias Point4I = Point4(Int32)

  # A four-dimensional point.
  # Contains x, y, z, and w-coordinates.
  # The coordinates are a 64-bit integers.
  alias Point4L = Point4(Int64)

  # A four-dimensional point.
  # Contains x, y, z, and w-coordinates.
  # The coordinates are a 32-bit floating-point numbers.
  alias Point4F = Point4(Float32)

  # A four-dimensional point.
  # Contains x, y, z, and w-coordinates.
  # The coordinates are a 64-bit floating-point numbers.
  alias Point4D = Point4(Float64)
end
