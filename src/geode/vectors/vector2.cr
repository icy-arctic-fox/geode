require "../angles"
require "./base"

module Geode
  # Vector containing two components.
  # Provides a collection of scalars of the same type.
  #
  # *T* is the scalar type.
  struct Vector2(T) < VectorBase(T, 2)
    # Constructs a vector with existing components.
    #
    # The type of the components is derived from the type of each argument.
    #
    # ```
    # Vector2[1, 2] # => (1, 2)
    # ```
    def self.[](x : T, y : T)
      Vector2.new(x, y)
    end

    # Constructs a vector with existing components.
    #
    # The type of the components is specified by the type parameter.
    # Each value is cast to the type *T*.
    #
    # ```
    # Vector2F[1, 2] # => (1.0, 2.0)
    # ```
    def self.[](x, y)
      Vector2.new(T.new(x), T.new(y))
    end

    # Ensures that another vector and this one have the same size at compile-time.
    #
    # The *size* argument should be the type argument from the other vector type.
    #
    # ```
    # def something(other : CommonVector(T, N))
    #   same_size!(N)
    #   # ...
    # end
    # ```
    private macro same_size!(size)
      \{% raise "Vectors must be the same size for this operation (#{{{size}}} != 2)" if {{size}} != 2 %}
    end

    # Creates a vector from its components.
    def initialize(x : T, y : T)
      array = uninitialized T[2]
      array[0] = x
      array[1] = y
      initialize(array)
    end

    # Creates a vector from its components.
    def initialize(components : Tuple(T, T))
      initialize(*components)
    end

    # Constructs the vector with pre-existing values.
    def initialize(array : StaticArray(T, 2))
      super
    end

    # Copies the contents of another vector.
    def initialize(other : CommonVector(T, 2))
      super
    end

    # Constructs the vector by yielding for each component.
    #
    # The value of each component should be returned from the block.
    # The block will be given the index of each component as an argument.
    #
    # ```
    # Vector2(Int32).new { |i| i * 5 } # => (0, 5)
    # ```
    def initialize(& : Int32 -> T)
      super { |i| yield i }
    end

    # Retrieves the x component.
    def x : T
      unsafe_fetch(0)
    end

    # Retrieves the y component.
    def y : T
      unsafe_fetch(1)
    end

    # Retrieves the components as a tuple.
    def tuple : Tuple(T, T)
      {x, y}
    end

    # Computes the rotation of the vector.
    #
    # Returns the value as radians.
    # The value will be between 0 and 2 pi.
    #
    # ```
    # Vector2[1, 1].angle # => 0.785398163
    # ```
    def angle : Number
      (signed_angle + Math::TAU) % Math::TAU
    end

    # Computes the rotation of the vector.
    #
    # Returns the value as radians.
    # The value will be between -pi and +pi.
    #
    # ```
    # Vector2[1, 1].signed_angle   # => 0.785398163
    # Vector2[-1, -1].signed_angle # => -2.35619449
    # ```
    def signed_angle : Number
      Math.atan2(y, x)
    end

    # Computes the angle between this vector and another.
    #
    # Returns the value as radians.
    # The value will be between -pi and +pi.
    #
    # The smallest angle between the vectors is calculated.
    #
    # Positive values indicate that the *other* vector can be reached by rotating this vector in a *positive* direction.
    # On a standard coordinate system, this means rotating counter-clockwise.
    # Negative values indicate the opposite - clockwise rotation.
    #
    # ```
    # Vector2[1, 1].signed_angle(Vector2[-1, 0]) # => 2.35619449
    # Vector2[1, 1].signed_angle(Vector2[1, -1]) # => -1.570796327
    # ```
    def signed_angle(other : CommonVector(U, 2)) : Number forall U
      angle = angle(other)
      sign = unsafe_fetch(0) * other.unsafe_fetch(1) - unsafe_fetch(1) * other.unsafe_fetch(0)
      Math.copysign(angle, sign)
    end

    # Computes a new vector from rotating this one.
    #
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # Vector2[1.0, 1.0].rotate(180.degrees) # => (-1.0, -1.0)
    # ```
    def rotate(angle : Number | Angle) : Vector2
      rad = angle.to_f
      cos = Math.cos(rad)
      sin = Math.sin(rad)
      x = T.new(self.x * cos - self.y * sin)
      y = T.new(self.x * sin + self.y * cos)
      self.class.new(x, y)
    end

    # Converts this vector to a row vector,
    # in other words a matrix with one row.
    #
    # ```
    # vector = Vector2[1, 2]
    # vector.to_row # => [[1, 2]]
    # ```
    def to_row : Matrix1x2(T)
      Matrix1x2.new(@array)
    end

    # Converts this vector to a column vector,
    # in other words a matrix with one column.
    #
    # ```
    # vector = Vector2[1, 2]
    # vector.to_column # => [[1], [2]]
    # ```
    def to_column : Matrix2x1(T)
      Matrix2x1.new(@array)
    end
  end

  # A two-dimensional vector.
  # Contains an x and y component.
  # The components are 32-bit integers.
  alias Vector2I = Vector2(Int32)

  # A two-dimensional vector.
  # Contains an x and y component.
  # The components are 64-bit integers.
  alias Vector2L = Vector2(Int64)

  # A two-dimensional vector.
  # Contains an x and y component.
  # The components are 32-bit floating-point numbers.
  alias Vector2F = Vector2(Float32)

  # A two-dimensional vector.
  # Contains an x and y component.
  # The components are 64-bit floating-point numbers.
  alias Vector2D = Vector2(Float64)
end
