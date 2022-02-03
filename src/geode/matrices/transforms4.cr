module Geode
  # Transformation that can be performed in four-dimensions with matrices.
  #
  # Multiplying a 4D object by the matrices produced by these methods will apply the operation to the object.
  # The matrix must be on the right-hand-side of the multiplication operation.
  #
  # ```
  # object * matrix
  # ```
  #
  # Matrix multiplication is not commutative, therefore the ordering matters.
  # If it's desired to have the matrix on the left-hand-side, transpose it before multiplying.
  #
  # ```
  # matrix.transpose * object
  # ```
  #
  # To combine multiple operations, multiply the matrices from these methods together.
  #
  # This module should be extended.
  module MatrixTransformConstructors4(T)
    # Creates a 3D rotation matrix with space for translation.
    #
    # Multiplying an object by this matrix will rotate it the specified amount.
    # The *angle* must be a `Number` in radians or an `Angle`.
    # The object is rotated around the specified *axis*.
    #
    # ```
    # axis = Vector3[1, 1, 1].normalize
    # vector = Vector4[1, 2, 3, 1]
    # matrix = Matrix4(Float64).rotate(45.degrees, axis)
    # vector * matrix # => (1.701141509, 1.183503419, 3.115355072, 1.0)
    # ```
    def rotate(angle : Number | Angle, axis : CommonVector(T, 3)) : self
      norm = axis.normalize
      x = norm.unsafe_fetch(0)
      y = norm.unsafe_fetch(1)
      z = norm.unsafe_fetch(2)

      rad = angle.to_f
      sin = T.new(Math.sin(rad))
      cos = T.new(Math.cos(rad))
      inv = T.multiplicative_identity - cos

      xx = x.abs2 * inv
      yy = y.abs2 * inv
      zz = z.abs2 * inv
      xy = x * y * inv
      xz = x * z * inv
      yz = y * z * inv

      x_sin = x * sin
      y_sin = y * sin
      z_sin = z * sin

      new(StaticArray[
        xx + cos, xy + z_sin, xz - y_sin, T.zero,
        xy - z_sin, yy + cos, yz + x_sin, T.zero,
        xz + y_sin, yz - x_sin, zz + cos, T.zero,
        T.zero, T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D rotation matrix with space for translation.
    #
    # Multiplying an object by this matrix will rotate it around the x-axis.
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # vector = Vector4[1, 1, 1, 1]
    # matrix = Matrix4(Float64).rotate_x(45.degrees)
    # vector * matrix # => (1.0, 0.0, 1.414213562, 1.0)
    # ```
    def rotate_x(angle : Number | Angle) : self
      rad = angle.to_f
      sin = T.new(Math.sin(rad))
      cos = T.new(Math.cos(rad))

      new(StaticArray[
        T.multiplicative_identity, T.zero, T.zero, T.zero,
        T.zero, cos, sin, T.zero,
        T.zero, -sin, cos, T.zero,
        T.zero, T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D rotation matrix with space for translation.
    #
    # Multiplying an object by this matrix will rotate it around the y-axis.
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # vector = Vector4[1, 1, 1, 1]
    # matrix = Matrix4(Float64).rotate_y(45.degrees)
    # vector * matrix # => (1.414213562, 1.0, 0.0, 1.0)
    # ```
    def rotate_y(angle : Number | Angle) : self
      rad = angle.to_f
      sin = T.new(Math.sin(rad))
      cos = T.new(Math.cos(rad))

      new(StaticArray[
        cos, T.zero, -sin, T.zero,
        T.zero, T.multiplicative_identity, T.zero, T.zero,
        sin, T.zero, cos, T.zero,
        T.zero, T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D rotation matrix with space for translation.
    #
    # Multiplying an object by this matrix will rotate it around the z-axis.
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # vector = Vector4[1, 1, 1, 1]
    # matrix = Matrix4(Float64).rotate_z(45.degrees)
    # vector * matrix # => (0.0, 1.414213562, 1.0, 1.0)
    # ```
    def rotate_z(angle : Number | Angle) : self
      rad = angle.to_f
      sin = T.new(Math.sin(rad))
      cos = T.new(Math.cos(rad))

      new(StaticArray[
        cos, sin, T.zero, T.zero,
        -sin, cos, T.zero, T.zero,
        T.zero, T.zero, T.multiplicative_identity, T.zero,
        T.zero, T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D scaling matrix with space for translation.
    #
    # Uniformly scales an object.
    # Multiplying an object by this matrix will scale it by *amount*.
    # Values for *amount* smaller than 1 will shrink it.
    # Values larger than 1 will enlarge it.
    # Negative values will flip it.
    #
    # ```
    # vector = Vector4[2, 3, 4, 1]
    # matrix = Matrix4(Float64).scale(2)
    # vector * matrix # => (4.0, 6.0, 8.0, 1.0)
    # ```
    def scale(amount : T) : self
      new(StaticArray[
        amount, T.zero, T.zero, T.zero,
        T.zero, amount, T.zero, T.zero,
        T.zero, T.zero, amount, T.zero,
        T.zero, T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D scaling matrix with space for translation.
    #
    # Non-uniformly scales an object (squash and stretch).
    # Multiplying an object by this matrix will scale it by *x* amount along the x-axis and *y* amount along the y-axis.
    # Values for *x* and *y* smaller than 1 will shrink it.
    # Values larger than 1 will enlarge it.
    # Negative values will flip it.
    #
    # ```
    # vector = Vector4[2, 3, 4, 1]
    # matrix = Matrix4(Float64).scale(1.5, 2, 2.5)
    # vector * matrix # => (3.0, 6.0, 9.0, 1.0)
    # ```
    def scale(x : T, y : T, z : T) : self
      new(StaticArray[
        x, T.zero, T.zero, T.zero,
        T.zero, y, T.zero, T.zero,
        T.zero, T.zero, z, T.zero,
        T.zero, T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D reflecting matrix with space for translation.
    #
    # Multiplying an object by this matrix will reflect it along the x-axis.
    #
    # ```
    # vector = Vector4[1, 2, 3, 1]
    # matrix = Matrix4(Int32).reflect_x
    # vector * matrix # => (-1, 2, 3, 1)
    # ```
    def reflect_x : self
      new(StaticArray[
        -T.multiplicative_identity, T.zero, T.zero, T.zero,
        T.zero, T.multiplicative_identity, T.zero, T.zero,
        T.zero, T.zero, T.multiplicative_identity, T.zero,
        T.zero, T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D reflective matrix with space for translation.
    #
    # Multiplying an object by this matrix will reflect it along the y-axis.
    #
    # ```
    # vector = Vector4[1, 2, 3, 1]
    # matrix = Matrix4(Int32).reflect_y
    # vector * matrix # => (1, -2, 3, 1)
    # ```
    def reflect_y : self
      new(StaticArray[
        T.multiplicative_identity, T.zero, T.zero, T.zero,
        T.zero, -T.multiplicative_identity, T.zero, T.zero,
        T.zero, T.zero, T.multiplicative_identity, T.zero,
        T.zero, T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D reflecting matrix with space for translation.
    #
    # Multiplying an object by this matrix will reflect it along the z-axis.
    #
    # ```
    # vector = Vector4[1, 2, 3, 1]
    # matrix = Matrix4(Int32).reflect_x
    # vector * matrix # => (1, 2, -3, 1)
    # ```
    def reflect_z : self
      new(StaticArray[
        T.multiplicative_identity, T.zero, T.zero, T.zero,
        T.zero, T.multiplicative_identity, T.zero, T.zero,
        T.zero, T.zero, -T.multiplicative_identity, T.zero,
        T.zero, T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D shearing matrix with space for translation.
    #
    # Multiplying an object by this matrix
    # will shear it along the y and z-axis based on the x-axis.
    # For each unit along the x-axis, the y value will be adjusted by *y*
    # and the z value will be adjusted by *z*.
    #
    # ```
    # vector = Vector4[2, 3, 4, 1]
    # matrix = Matrix4(Int32).shear_x(2, 3)
    # vector * matrix # => (2, 7, 10, 1)
    # ```
    def shear_x(y : T, z : T) : self
      new(StaticArray[
        T.multiplicative_identity, y, z, T.zero,
        T.zero, T.multiplicative_identity, T.zero, T.zero,
        T.zero, T.zero, T.multiplicative_identity, T.zero,
        T.zero, T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D shearing matrix with space for translation.
    #
    # Multiplying an object by this matrix
    # will shear it along the x and z-axis based on the y-axis.
    # For each unit along the y-axis, the x value will be adjusted by *x*
    # and the z value will be adjusted by *z*.
    #
    # ```
    # vector = Vector4[2, 3, 4, 1]
    # matrix = Matrix4(Int32).shear_y(2, 3)
    # vector * matrix # => (8, 3, 13, 1)
    # ```
    def shear_y(x : T, z : T) : self
      new(StaticArray[
        T.multiplicative_identity, T.zero, T.zero, T.zero,
        x, T.multiplicative_identity, z, T.zero,
        T.zero, T.zero, T.multiplicative_identity, T.zero,
        T.zero, T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D shearing matrix with space for translation.
    #
    # Multiplying an object by this matrix
    # will shear it along the x and y-axis based on the z-axis.
    # For each unit along the z-axis, the x value will be adjusted by *x*
    # and the y value will be adjusted by *y*.
    #
    # ```
    # vector = Vector4[2, 3, 4, 1]
    # matrix = Matrix4(Int32).shear_z(2, 3)
    # vector * matrix # => (10, 15, 4, 1)
    # ```
    def shear_z(x : T, y : T) : self
      new(StaticArray[
        T.multiplicative_identity, T.zero, T.zero, T.zero,
        T.zero, T.multiplicative_identity, T.zero, T.zero,
        x, y, T.multiplicative_identity, T.zero,
        T.zero, T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D transform matrix.
    #
    # ```
    # vector = Vector4[3, 5, 7, 1]
    # matrix = Matrix4(Int32).translate(3, 2, 1)
    # vector * matrix # => (6, 7, 8, 1)
    # ```
    def translate(x : T, y : T, z : T) : self
      new(StaticArray[
        T.multiplicative_identity, T.zero, T.zero, T.zero,
        T.zero, T.multiplicative_identity, T.zero, T.zero,
        T.zero, T.zero, T.multiplicative_identity, T.zero,
        x, y, z, T.multiplicative_identity,
      ])
    end
  end
end
