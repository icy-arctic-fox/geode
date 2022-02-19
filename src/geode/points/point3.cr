require "./point"

module Geode
  # Three dimensional point.
  #
  # *T* is the scalar type.
  struct Point3(T) < Point(T, 3)
    # Constructs a point with existing coordinates.
    #
    # The type of the coordinates is derived from the type of each argument.
    #
    # ```
    # Point3[1, 2, 3] # => (1, 2, 3)
    # ```
    def self.[](x : T, y : T, z : T)
      new(x, y, z)
    end

    # Constructs a point with existing coordinates.
    #
    # The type of the coordinates is specified by the type parameter.
    # Each value is cast to the type *T*.
    #
    # ```
    # Point3F[1, 2, 3] # => (1.0, 2.0, 3.0)
    # ```
    def self.[](x, y, z)
      new(T.new(x), T.new(y), T.new(z))
    end

    # Creates a point from its coordinates.
    def initialize(x : T, y : T, z : T)
      array = uninitialized T[3]
      array[0] = x
      array[1] = y
      array[2] = z
      initialize(array)
    end

    # Constructs the point by yielding for each coordinate.
    #
    # The value of each coordinate should be returned from the block.
    # The block will be given the index of each coordinate as an argument.
    #
    # ```
    # Point3(Int32).new { |i| i + 5 } # => (5, 6, 7)
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

    # Converts this point to a vector.
    #
    # ```
    # point = Point3[5, 7, 9]
    # point.to_vector # => (5, 7, 9)
    # ```
    def to_vector
      Vector3(T).new(@array)
    end

    # Retrieves the coordinates as a tuple.
    def tuple : Tuple(T, T, T)
      {x, y, z}
    end

    # Converts this point to a row vector,
    # in other words a matrix with one row.
    #
    # ```
    # point = Point3[5, 7, 9]
    # point.to_row # => [[5, 7, 9]]
    # ```
    def to_row : Matrix1x3(T)
      Matrix1x3.new(@array)
    end

    # Converts this point to a column vector,
    # in other words a matrix with one column.
    #
    # ```
    # point = Point3[5, 7, 9]
    # point.to_column # => [[5], [7], [9]]
    # ```
    def to_column : Matrix3x1(T)
      Matrix3x1.new(@array)
    end

    # Produces a debugger-friendly string representation of the point.
    def inspect(io : IO) : Nil
      io << self.class << "#<x: " << x << ", y: " << y << ", z: " << z << '>'
    end
  end

  # A three-dimensional point.
  # Contains x, y, and z-coordinates.
  # The coordinates are 32-bit integers.
  alias Point3I = Point3(Int32)

  # A three-dimensional point.
  # Contains x, y, and z-coordinates.
  # The coordinates are a 64-bit integers.
  alias Point3L = Point3(Int64)

  # A three-dimensional point.
  # Contains x, y, and z-coordinates.
  # The coordinates are a 32-bit floating-point numbers.
  alias Point3F = Point3(Float32)

  # A three-dimensional point.
  # Contains x, y, and z-coordinates.
  # The coordinates are a 64-bit floating-point numbers.
  alias Point3D = Point3(Float64)
end
