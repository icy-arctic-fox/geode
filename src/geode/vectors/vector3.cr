require "./base"

module Geode
  # Vector containing three components.
  # Provides a collection of scalars of the same type.
  #
  # *T* is the scalar type.
  struct Vector3(T) < VectorBase(T, 3)
    # Constructs a vector with existing components.
    #
    # The type of the components is derived from the type of each argument.
    #
    # ```
    # Vector3[1, 2, 3] # => (1, 2, 3)
    # ```
    def self.[](x : T, y : T, z : T)
      Vector3.new(x, y, z)
    end

    # Constructs a vector with existing components.
    #
    # The type of the components is specified by the type parameter.
    # Each value is cast to the type *T*.
    #
    # ```
    # Vector3F[1, 2, 3] # => (1.0, 2.0, 3.0)
    # ```
    def self.[](x, y, z)
      Vector3.new(T.new(x), T.new(y), T.new(z))
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
      \{% raise "Vectors must be the same size for this operation (#{{{size}}} != 3)" if {{size}} != 3 %}
    end

    # Creates a vector from its components.
    def initialize(x : T, y : T, z : T)
      array = uninitialized T[3]
      array[0] = x
      array[1] = y
      array[2] = z
      initialize(array)
    end

    # Creates a vector from its components.
    def initialize(components : Tuple(T, T, T))
      initialize(*components)
    end

    # Constructs the vector with pre-existing values.
    def initialize(array : StaticArray(T, 3))
      super
    end

    # Copies the contents of another vector.
    def initialize(other : CommonVector(T, 3))
      super
    end

    # Constructs the vector by yielding for each component.
    #
    # The value of each component should be returned from the block.
    # The block will be given the index of each component as an argument.
    #
    # ```
    # Vector3(Int32).new { |i| i * 5 } # => (0, 5, 10)
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

    # Retrieves the z component.
    def z : T
      unsafe_fetch(2)
    end

    # Retrieves the components as a tuple.
    def tuple : Tuple(T, T, T)
      {x, y, z}
    end

    # Computes the angle (directional cosine) of the vector from the x-axis.
    #
    # The value will be in radians from 0 to pi.
    #
    # ```
    # Vector3[1, 2, 3].alpha # => 1.300246563
    # ```
    def alpha : Number
      Math.acos(x / mag)
    end

    # Computes the angle (directional cosine) of the vector from the y-axis.
    #
    # The value will be in radians from 0 to pi.
    #
    # ```
    # Vector3[1, 2, 3].beta # => 1.006853685
    # ```
    def beta : Number
      Math.acos(y / mag)
    end

    # Computes the angle (directional cosine) of the vector from the z-axis.
    #
    # The value will be in radians from 0 to pi.
    #
    # ```
    # Vector3[1, 2, 3].gamma # => 0.640522312
    # ```
    def gamma : Number
      Math.acos(z / mag)
    end

    # Computes the cross-product of this and another vector.
    #
    # ```
    # Vector3[1, 3, 4].cross(Vector3[2, -5, 8]) # => (44, 0, -11)
    # ```
    def cross(other : CommonVector(U, 3)) : CommonVector forall U
      x1 = unsafe_fetch(0)
      y1 = unsafe_fetch(1)
      z1 = unsafe_fetch(2)
      x2 = other.unsafe_fetch(0)
      y2 = other.unsafe_fetch(1)
      z2 = other.unsafe_fetch(2)
      x = y1 * z2 - z1 * y2
      y = z1 * x2 - x1 * z2
      z = x1 * y2 - y1 * x2
      self.class.new(x, y, z)
    end

    # Computes a new vector that is rotated around an arbitrary axis.
    #
    # The *angle* bus be a `Number` in radians or an `Angle`.
    #
    # TODO: Not implemented.
    def rotate(angle : Number | Angle, axis : CommonVector(U, 3)) : CommonVector forall U
      raise NotImplementedError.new("#rotate")
    end

    # Computes a new vector that is rotated around the x-axis.
    #
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # Vector3[1.0, 1.0, 1.0].rotate_x(90.degrees) # => (1.0, -1.0, 1.0)
    # ```
    def rotate_x(angle : Number | Angle) : Vector3
      rad = angle.to_f
      sin = Math.sin(rad)
      cos = Math.cos(rad)
      y = T.new(self.y * cos - self.z * sin)
      z = T.new(self.y * sin + self.z * cos)
      self.class.new(x, y, z)
    end

    # Computes a new vector that is rotated around the y-axis.
    #
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # Vector3[1.0, 1.0, 1.0].rotate_y(90.degrees) # => (1.0, 1.0, -1.0)
    # ```
    def rotate_y(angle : Number | Angle) : Vector3
      rad = angle.to_f
      sin = Math.sin(rad)
      cos = Math.cos(rad)
      x = T.new(self.x * cos + self.z * sin)
      z = T.new(self.z * cos - self.x * sin)
      self.class.new(x, y, z)
    end

    # Computes a new vector that is rotated around the z-axis.
    #
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # Vector3[1.0, 1.0, 1.0].rotate_z(90.degrees) # => (-1.0, 1.0, 1.0)
    # ```
    def rotate_z(angle : Number | Angle) : Vector3
      rad = angle.to_f
      sin = Math.sin(rad)
      cos = Math.cos(rad)
      x = T.new(self.x * cos - self.y * sin)
      y = T.new(self.x * sin + self.y * cos)
      self.class.new(x, y, z)
    end

    # Converts this vector to a row vector,
    # in other words a matrix with one row.
    #
    # ```
    # vector = Vector3[1, 2, 3]
    # vector.to_row # => [[1, 2, 3]]
    # ```
    def to_row : Matrix1x3(T)
      Matrix1x3.new(@array)
    end

    # Converts this vector to a column vector,
    # in other words a matrix with one column.
    #
    # ```
    # vector = Vector3[1, 2, 3]
    # vector.to_column # => [[1], [2], [3]]
    # ```
    def to_column : Matrix3x1(T)
      Matrix3x1.new(@array)
    end
  end

  # A three-dimensional vector.
  # Contains an x, y, and z component.
  # The components are 32-bit integers.
  alias Vector3I = Vector3(Int32)

  # A three-dimensional vector.
  # Contains an x, y, and z component.
  # The components are 64-bit integers.
  alias Vector3L = Vector3(Int64)

  # A three-dimensional vector.
  # Contains an x, y, and z component.
  # The components are 32-bit floating-point numbers.
  alias Vector3F = Vector3(Float32)

  # A three-dimensional vector.
  # Contains an x, y, and z component.
  # The components are 64-bit floating-point numbers.
  alias Vector3D = Vector3(Float64)
end
