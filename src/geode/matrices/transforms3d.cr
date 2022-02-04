module Geode
  # Transformation that can be performed in three-dimensions with 3x3 matrices.
  #
  # Multiplying a 3D object by the matrices produced by these methods will apply the operation to the object.
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
  module Matrix3x3Transforms3DConstructors(T)
    # Creates a 3D rotation matrix.
    #
    # Multiplying a 3D object by this matrix will rotate it the specified amount.
    # The *angle* must be a `Number` in radians or an `Angle`.
    # The object is rotated around the specified *axis*.
    #
    # ```
    # axis = Vector3[1, 1, 1].normalize
    # vector = Vector3[1, 2, 3]
    # matrix = Matrix3(Float64).rotate(45.degrees, axis)
    # vector * matrix # => (1.701141509, 1.183503419, 3.115355072)
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
        xx + cos, xy + z_sin, xz - y_sin,
        xy - z_sin, yy + cos, yz + x_sin,
        xz + y_sin, yz - x_sin, zz + cos,
      ])
    end

    # Creates a 3D rotation matrix.
    #
    # Multiplying a 3D object by this matrix will rotate it around the x-axis.
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # vector = Vector3[1, 1, 1]
    # matrix = Matrix3(Float64).rotate_x(45.degrees)
    # vector * matrix # => (1.0, 0.0, 1.414213562)
    # ```
    def rotate_x(angle : Number | Angle) : self
      rad = angle.to_f
      sin = T.new(Math.sin(rad))
      cos = T.new(Math.cos(rad))

      new(StaticArray[
        T.multiplicative_identity, T.zero, T.zero,
        T.zero, cos, sin,
        T.zero, -sin, cos,
      ])
    end

    # Creates a 3D rotation matrix.
    #
    # Multiplying a 3D object by this matrix will rotate it around the y-axis.
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # vector = Vector3[1, 1, 1]
    # matrix = Matrix3(Float64).rotate_y(45.degrees)
    # vector * matrix # => (1.414213562, 1.0, 0.0)
    # ```
    def rotate_y(angle : Number | Angle) : self
      rad = angle.to_f
      sin = T.new(Math.sin(rad))
      cos = T.new(Math.cos(rad))

      new(StaticArray[
        cos, T.zero, -sin,
        T.zero, T.multiplicative_identity, T.zero,
        sin, T.zero, cos,
      ])
    end

    # Creates a 3D rotation matrix.
    #
    # Multiplying a 3D object by this matrix will rotate it around the z-axis.
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # vector = Vector3[1, 1, 1]
    # matrix = Matrix3(Float64).rotate_z(45.degrees)
    # vector * matrix # => (0.0, 1.414213562, 1.0)
    # ```
    def rotate_z(angle : Number | Angle) : self
      rad = angle.to_f
      sin = T.new(Math.sin(rad))
      cos = T.new(Math.cos(rad))

      new(StaticArray[
        cos, sin, T.zero,
        -sin, cos, T.zero,
        T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D scaling matrix.
    #
    # Uniformly scales an object.
    # Multiplying a 3D object by this matrix will scale it by *amount*.
    # Values for *amount* smaller than 1 will shrink it.
    # Values larger than 1 will enlarge it.
    # Negative values will flip it.
    #
    # ```
    # vector = Vector3[2, 3, 4]
    # matrix = Matrix3(Int32).scale(2)
    # vector * matrix # => (4, 6, 8)
    # ```
    def scale(amount : T) : self
      new(StaticArray[
        amount, T.zero, T.zero,
        T.zero, amount, T.zero,
        T.zero, T.zero, amount,
      ])
    end

    # Creates a 3D scaling matrix.
    #
    # Non-uniformly scales an object (squash and stretch).
    # Multiplying a 3D object by this matrix will scale it by *x* amount along the x-axis and *y* amount along the y-axis.
    # Values for *x* and *y* smaller than 1 will shrink it.
    # Values larger than 1 will enlarge it.
    # Negative values will flip it.
    #
    # ```
    # vector = Vector3[2, 3, 4]
    # matrix = Matrix3(Float64).scale(1.5, 2, 2.5)
    # vector * matrix # => (3.0, 6.0, 9.0)
    # ```
    def scale(x : T, y : T, z : T) : self
      new(StaticArray[
        x, T.zero, T.zero,
        T.zero, y, T.zero,
        T.zero, T.zero, z,
      ])
    end

    # Creates a 3D reflecting matrix.
    #
    # Multiplying a 3D object by this matrix will reflect it along the x-axis.
    #
    # ```
    # vector = Vector3[1, 2, 3]
    # matrix = Matrix3(Int32).reflect_x
    # vector * matrix # => (-1, 2, 3)
    # ```
    def reflect_x : self
      new(StaticArray[
        -T.multiplicative_identity, T.zero, T.zero,
        T.zero, T.multiplicative_identity, T.zero,
        T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D reflective matrix.
    #
    # Multiplying a 3D object by this matrix will reflect it along the y-axis.
    #
    # ```
    # vector = Vector3[1, 2, 3]
    # matrix = Matrix3(Int32).reflect_y
    # vector * matrix # => (1, -2, 3)
    # ```
    def reflect_y : self
      new(StaticArray[
        T.multiplicative_identity, T.zero, T.zero,
        T.zero, -T.multiplicative_identity, T.zero,
        T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D reflecting matrix.
    #
    # Multiplying a 3D object by this matrix will reflect it along the z-axis.
    #
    # ```
    # vector = Vector3[1, 2, 3]
    # matrix = Matrix3(Int32).reflect_x
    # vector * matrix # => (1, 2, -3)
    # ```
    def reflect_z : self
      new(StaticArray[
        T.multiplicative_identity, T.zero, T.zero,
        T.zero, T.multiplicative_identity, T.zero,
        T.zero, T.zero, -T.multiplicative_identity,
      ])
    end

    # Creates a 3D shearing matrix.
    #
    # Multiplying a 3D object by this matrix
    # will shear it along the y and z-axis based on the x-axis.
    # For each unit along the x-axis, the y value will be adjusted by *y*
    # and the z value will be adjusted by *z*.
    #
    # ```
    # vector = Vector3[2, 3, 4]
    # matrix = Matrix3(Int32).shear_x(2, 3)
    # vector * matrix # => (2, 7, 10)
    # ```
    def shear_x(y : T, z : T) : self
      new(StaticArray[
        T.multiplicative_identity, y, z,
        T.zero, T.multiplicative_identity, T.zero,
        T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D shearing matrix.
    #
    # Multiplying a 3D object by this matrix
    # will shear it along the x and z-axis based on the y-axis.
    # For each unit along the y-axis, the x value will be adjusted by *x*
    # and the z value will be adjusted by *z*.
    #
    # ```
    # vector = Vector3[2, 3, 4]
    # matrix = Matrix3(Int32).shear_y(2, 3)
    # vector * matrix # => (8, 3, 13)
    # ```
    def shear_y(x : T, z : T) : self
      new(StaticArray[
        T.multiplicative_identity, T.zero, T.zero,
        x, T.multiplicative_identity, z,
        T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D shearing matrix.
    #
    # Multiplying a 3D object by this matrix
    # will shear it along the x and y-axis based on the z-axis.
    # For each unit along the z-axis, the x value will be adjusted by *x*
    # and the y value will be adjusted by *y*.
    #
    # ```
    # vector = Vector3[2, 3, 4]
    # matrix = Matrix3(Int32).shear_z(2, 3)
    # vector * matrix # => (10, 15, 4)
    # ```
    def shear_z(x : T, y : T) : self
      new(StaticArray[
        T.multiplicative_identity, T.zero, T.zero,
        T.zero, T.multiplicative_identity, T.zero,
        x, y, T.multiplicative_identity,
      ])
    end
  end

  # Transformation that can be performed in three-dimensions with 3x3 matrices.
  #
  # These methods produce a new matrix that has the operation performed on it.
  # This:
  # ```
  # matrix.rotate_x(45.degrees)
  # ```
  # is effectively the same as:
  # ```
  # matrix * Matrix3(Float64).rotate_x(45.degrees)
  # ```
  module Matrix3x3Transforms3D(T)
    # Returns a matrix that has a rotation transform applied.
    #
    # The *angle* must be a `Number` in radians or an `Angle`.
    # The object is rotated around the specified *axis*.
    #
    # ```
    # axis = Vector3[1, 1, 1].normalize
    # vector = Vector3[1, 2, 3]
    # matrix = Matrix3(Float64).identity.rotate(45.degrees, axis)
    # vector * matrix # => (1.701141509, 1.183503419, 3.115355072)
    # ```
    def rotate(angle : Number | Angle, axis : CommonVector(U, 3)) : CommonMatrix forall U
      norm = axis.normalize
      x = norm.unsafe_fetch(0)
      y = norm.unsafe_fetch(1)
      z = norm.unsafe_fetch(2)

      rad = angle.to_f
      sin = Math.sin(rad)
      cos = Math.cos(rad)
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

      a2 = xx + cos
      b2 = xy + z_sin
      c2 = xz - y_sin
      d2 = xy - z_sin
      e2 = yy + cos
      f2 = yz + x_sin
      g2 = xz + y_sin
      h2 = yz - x_sin
      i2 = zz + cos

      {{@type.name(generic_args: false)}}.new(StaticArray[
        a * a2 + b * d2 + c * g2, a * b2 + b * e2 + c * h2, a * c2 + b * f2 + c * i2,
        d * a2 + e * d2 + f * g2, d * b2 + e * e2 + f * h2, d * c2 + e * f2 + f * i2,
        g * a2 + h * d2 + i * g2, g * b2 + h * e2 + i * h2, g * c2 + h * f2 + i * i2,
      ])
    end

    # Returns a matrix that has a rotation transform applied.
    #
    # Multiplying a 3D object by this matrix will rotate it around the x-axis.
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # vector = Vector3[1, 1, 1]
    # matrix = Matrix3(Float64).identity.rotate_x(45.degrees)
    # vector * matrix # => (1.0, 0.0, 1.414213562)
    # ```
    def rotate_x(angle : Number | Angle) : CommonMatrix
      rad = angle.to_f
      sin = Math.sin(rad)
      cos = Math.cos(rad)

      {{@type.name(generic_args: false)}}.new(StaticArray[
        a, b * cos + c * -sin, b * sin + c * cos,
        d, e * cos + f * -sin, e * sin + f * cos,
        g, h * cos + i * -sin, h * sin + i * cos,
      ])
    end

    # Returns a matrix that has a rotation transform applied.
    #
    # Multiplying a 3D object by this matrix will rotate it around the y-axis.
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # vector = Vector3[1, 1, 1]
    # matrix = Matrix3(Float64).identity.rotate_y(45.degrees)
    # vector * matrix # => (1.414213562, 1.0, 0.0)
    # ```
    def rotate_y(angle : Number | Angle) : CommonMatrix
      rad = angle.to_f
      sin = Math.sin(rad)
      cos = Math.cos(rad)

      {{@type.name(generic_args: false)}}.new(StaticArray[
        a * cos + c * sin, b, a * -sin + c * cos,
        d * cos + f * sin, e, d * -sin + f * cos,
        g * cos + i * sin, h, g * -sin + i * cos,
      ])
    end

    # Returns a matrix that has a rotation transform applied.
    #
    # Multiplying a 3D object by this matrix will rotate it around the z-axis.
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # vector = Vector3[1, 1, 1]
    # matrix = Matrix3(Float64).identity.rotate_z(45.degrees)
    # vector * matrix # => (0.0, 1.414213562, 1.0)
    # ```
    def rotate_z(angle : Number | Angle) : CommonMatrix
      rad = angle.to_f
      sin = Math.sin(rad)
      cos = Math.cos(rad)

      {{@type.name(generic_args: false)}}.new(StaticArray[
        a * cos + b * -sin, a * sin + b * cos, c,
        d * cos + e * -sin, d * sin + e * cos, f,
        g * cos + h * -sin, g * sin + h * cos, i,
      ])
    end

    # Returns a matrix that has a scale transform applied.
    #
    # Uniformly scales an object.
    # Multiplying a 3D object by this matrix will scale it by *amount*.
    # Values for *amount* smaller than 1 will shrink it.
    # Values larger than 1 will enlarge it.
    # Negative values will flip it.
    #
    # ```
    # vector = Vector3[2, 3, 4]
    # matrix = Matrix3(Int32).identity.scale(2)
    # vector * matrix # => (4, 6, 8)
    # ```
    def scale(amount : Number) : CommonMatrix
      map &.*(amount)
    end

    # Returns a matrix that has a scale transform applied.
    #
    # Non-uniformly scales an object (squash and stretch).
    # Multiplying a 3D object by this matrix will scale it by *x* amount along the x-axis and *y* amount along the y-axis.
    # Values for *x* and *y* smaller than 1 will shrink it.
    # Values larger than 1 will enlarge it.
    # Negative values will flip it.
    #
    # ```
    # vector = Vector3[2, 3, 4]
    # matrix = Matrix3(Float64).identity.scale(1.5, 2, 2.5)
    # vector * matrix # => (3.0, 6.0, 9.0)
    # ```
    def scale(x, y, z) : CommonMatrix
      {{@type.name(generic_args: false)}}.new(StaticArray[
        a * x, b * y, c * z,
        d * x, e * y, f * z,
        g * x, h * y, i * z,
      ])
    end

    # Returns a matrix that has a reflection transform applied.
    #
    # Multiplying a 3D object by this matrix will reflect it along the x-axis.
    #
    # ```
    # vector = Vector3[1, 2, 3]
    # matrix = Matrix3(Int32).identity.reflect_x
    # vector * matrix # => (-1, 2, 3)
    # ```
    def reflect_x : self
      self.class.new(StaticArray[
        -a, b, c,
        -d, e, f,
        -g, h, i,
      ])
    end

    # Returns a matrix that has a reflection transform applied.
    #
    # Multiplying a 3D object by this matrix will reflect it along the y-axis.
    #
    # ```
    # vector = Vector3[1, 2, 3]
    # matrix = Matrix3(Int32).identity.reflect_y
    # vector * matrix # => (1, -2, 3)
    # ```
    def reflect_y : self
      self.class.new(StaticArray[
        a, -b, c,
        d, -e, f,
        g, -h, i,
      ])
    end

    # Returns a matrix that has a reflection transform applied.
    #
    # Multiplying a 3D object by this matrix will reflect it along the z-axis.
    #
    # ```
    # vector = Vector3[1, 2, 3]
    # matrix = Matrix3(Int32).identity.reflect_x
    # vector * matrix # => (1, 2, -3)
    # ```
    def reflect_z : self
      self.class.new(StaticArray[
        a, b, -c,
        d, e, -f,
        g, h, -i,
      ])
    end

    # Returns a matrix that has a shear transform applied.
    #
    # Multiplying a 3D object by this matrix
    # will shear it along the y and z-axis based on the x-axis.
    # For each unit along the x-axis, the y value will be adjusted by *y*
    # and the z value will be adjusted by *z*.
    #
    # ```
    # vector = Vector3[2, 3, 4]
    # matrix = Matrix3(Int32).identity.shear_x(2, 3)
    # vector * matrix # => (2, 7, 10)
    # ```
    def shear_x(y, z) : CommonMatrix
      {{@type.name(generic_args: false)}}.new(StaticArray[
        a, a * y + b, a * z + c,
        d, d * y + e, d * z + f,
        g, g * y + h, g * z + i,
      ])
    end

    # Returns a matrix that has a shear transform applied.
    #
    # Multiplying a 3D object by this matrix
    # will shear it along the x and z-axis based on the y-axis.
    # For each unit along the y-axis, the x value will be adjusted by *x*
    # and the z value will be adjusted by *z*.
    #
    # ```
    # vector = Vector3[2, 3, 4]
    # matrix = Matrix3(Int32).identity.shear_y(2, 3)
    # vector * matrix # => (8, 3, 13)
    # ```
    def shear_y(x, z) : CommonMatrix
      {{@type.name(generic_args: false)}}.new(StaticArray[
        a + b * x, b, b * z + c,
        d + e * x, e, e * z + f,
        g + h * x, h, h * z + i,
      ])
    end

    # Returns a matrix that has a shear transform applied.
    #
    # Multiplying a 3D object by this matrix
    # will shear it along the x and y-axis based on the z-axis.
    # For each unit along the z-axis, the x value will be adjusted by *x*
    # and the y value will be adjusted by *y*.
    #
    # ```
    # vector = Vector3[2, 3, 4]
    # matrix = Matrix3(Int32).identity.shear_z(2, 3)
    # vector * matrix # => (10, 15, 4)
    # ```
    def shear_z(x, y) : CommonMatrix
      {{@type.name(generic_args: false)}}.new(StaticArray[
        a + c * x, b + c * y, c,
        d + f * x, e + f * y, f,
        g + i * x, h + i * y, i,
      ])
    end

    # Returns a matrix with a translation applied.
    #
    # ```
    # vector = Vector4[3, 5, 7, 1]
    # matrix = Matrix3(Int32).identity.translate(3, 2, 1)
    # vector * matrix # => (6, 7, 8, 1)
    # ```
    def translate(x, y, z) : CommonMatrix
      Matrix4x4.new(StaticArray[
        a, b, c, T.zero,
        d, e, f, T.zero,
        g, h, i, T.zero,
        x, y, z, T.multiplicative_identity,
      ])
    end
  end

  # Transformation that can be performed in three-dimensions with 4x4 matrices.
  #
  # Multiplying a 3D object by the matrices produced by these methods will apply the operation to the object.
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
  module Matrix4x4Transforms3DConstructors(T)
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

  # Transformation that can be performed in three-dimensions with 4x4 matrices.
  #
  # These methods produce a new matrix that has the operation performed on it.
  # This:
  # ```
  # matrix.rotate_x(45.degrees)
  # ```
  # is effectively the same as:
  # ```
  # matrix * Matrix4(Float64).rotate_x(45.degrees)
  # ```
  module Matrix4x4Transforms3D(T)
    # Returns a matrix that has a rotation transform applied.
    #
    # The *angle* must be a `Number` in radians or an `Angle`.
    # The object is rotated around the specified *axis*.
    #
    # ```
    # axis = Vector4[1, 1, 1, 0].normalize
    # vector = Vector4[1, 2, 3, 1]
    # matrix = Matrix4(Float64).identity.rotate(45.degrees, axis)
    # vector * matrix # => (1.701141509, 1.183503419, 3.115355072, 1.0)
    # ```
    def rotate(angle : Number | Angle, axis : CommonVector(U, 3)) : CommonMatrix forall U
      norm = axis.normalize
      x = norm.unsafe_fetch(0)
      y = norm.unsafe_fetch(1)
      z = norm.unsafe_fetch(2)

      rad = angle.to_f
      sin = Math.sin(rad)
      cos = Math.cos(rad)
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

      a2 = xx + cos
      b2 = xy + z_sin
      c2 = xz - y_sin
      d2 = xy - z_sin
      e2 = yy + cos
      f2 = yz + x_sin
      g2 = xz + y_sin
      h2 = yz - x_sin
      i2 = zz + cos

      {{@type.name(generic_args: false)}}.new(StaticArray[
        a * a2 + b * d2 + c * g2, a * b2 + b * e2 + c * h2, a * c2 + b * f2 + c * i2, d,
        e * a2 + f * d2 + g * g2, e * b2 + f * e2 + g * h2, e * c2 + f * f2 + g * i2, h,
        i * a2 + j * d2 + k * g2, i * b2 + j * e2 + k * h2, i * c2 + j * f2 + k * i2, l,
        m, n, o, p,
      ])
    end

    # Returns a matrix that has a rotation transform applied.
    #
    # Multiplying a 3D object by this matrix will rotate it around the x-axis.
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # vector = Vector4[1, 1, 1, 1]
    # matrix = Matrix4(Float64).identity.rotate_x(45.degrees)
    # vector * matrix # => (1.0, 0.0, 1.414213562, 1.0)
    # ```
    def rotate_x(angle : Number | Angle) : CommonMatrix
      rad = angle.to_f
      sin = Math.sin(rad)
      cos = Math.cos(rad)

      {{@type.name(generic_args: false)}}.new(StaticArray[
        a, b * cos + c * -sin, b * sin + c * cos, d,
        e, f * cos + g * -sin, f * sin + g * cos, h,
        i, j * cos + k * -sin, j * sin + k * cos, l,
        m, n, o, p,
      ])
    end

    # Returns a matrix that has a rotation transform applied.
    #
    # Multiplying a 3D object by this matrix will rotate it around the y-axis.
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # vector = Vector4[1, 1, 1, 1]
    # matrix = Matrix4(Float64).identity.rotate_y(45.degrees)
    # vector * matrix # => (1.414213562, 1.0, 0.0, 1.0)
    # ```
    def rotate_y(angle : Number | Angle) : CommonMatrix
      rad = angle.to_f
      sin = Math.sin(rad)
      cos = Math.cos(rad)

      {{@type.name(generic_args: false)}}.new(StaticArray[
        a * cos + c * sin, b, a * -sin + c * cos, d,
        e * cos + g * sin, f, e * -sin + g * cos, h,
        i * cos + k * sin, j, i * -sin + k * cos, l,
        m, n, o, p,
      ])
    end

    # Returns a matrix that has a rotation transform applied.
    #
    # Multiplying a 3D object by this matrix will rotate it around the z-axis.
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # vector = Vector4[1, 1, 1, 1]
    # matrix = Matrix4(Float64).identity.rotate_z(45.degrees)
    # vector * matrix # => (0.0, 1.414213562, 1.0, 1.0)
    # ```
    def rotate_z(angle : Number | Angle) : CommonMatrix
      rad = angle.to_f
      sin = Math.sin(rad)
      cos = Math.cos(rad)

      {{@type.name(generic_args: false)}}.new(StaticArray[
        a * cos + b * -sin, a * sin + b * cos, c, d,
        e * cos + f * -sin, e * sin + f * cos, g, h,
        i * cos + j * -sin, i * sin + j * cos, k, l,
        m, n, o, p,
      ])
    end

    # Returns a matrix that has a scale transform applied.
    #
    # Uniformly scales an object.
    # Multiplying a 3D object by this matrix will scale it by *amount*.
    # Values for *amount* smaller than 1 will shrink it.
    # Values larger than 1 will enlarge it.
    # Negative values will flip it.
    #
    # ```
    # vector = Vector4[2, 3, 4, 1]
    # matrix = Matrix4(Int32).identity.scale3(2)
    # vector * matrix # => (4, 6, 8, 1)
    # ```
    def scale3(amount : Number) : CommonMatrix
      {{@type.name(generic_args: false)}}.new(StaticArray[
        a * amount, b, c, d,
        e, f * amount, g, h,
        i, j, k * amount, l,
        m, n, o, p,
      ])
    end

    # Returns a matrix that has a scale transform applied.
    #
    # Non-uniformly scales an object (squash and stretch).
    # Multiplying a 3D object by this matrix will scale it by *x* amount along the x-axis and *y* amount along the y-axis.
    # Values for *x* and *y* smaller than 1 will shrink it.
    # Values larger than 1 will enlarge it.
    # Negative values will flip it.
    #
    # ```
    # vector = Vector4[2, 3, 4, 1]
    # matrix = Matrix4(Float64).identity.scale(1.5, 2, 2.5)
    # vector * matrix # => (3.0, 6.0, 9.0, 1.0)
    # ```
    def scale(x, y, z) : CommonMatrix
      {{@type.name(generic_args: false)}}.new(StaticArray[
        a * x, b * y, c * z, d,
        e * x, f * y, g * z, h,
        i * x, j * y, k * z, l,
        m, n, o, p,
      ])
    end

    # Returns a matrix that has a reflection transform applied.
    #
    # Multiplying a 3D object by this matrix will reflect it along the x-axis.
    #
    # ```
    # vector = Vector4[1, 2, 3, 1]
    # matrix = Matrix4(Int32).identity.reflect_x
    # vector * matrix # => (-1, 2, 3, 1)
    # ```
    def reflect_x : self
      self.class.new(StaticArray[
        -a, b, c, d,
        -e, f, g, h,
        -i, j, k, l,
        m, n, o, p,
      ])
    end

    # Returns a matrix that has a reflection transform applied.
    #
    # Multiplying a 3D object by this matrix will reflect it along the y-axis.
    #
    # ```
    # vector = Vector4[1, 2, 3, 1]
    # matrix = Matrix4(Int32).identity.reflect_y
    # vector * matrix # => (1, -2, 3, 1)
    # ```
    def reflect_y : self
      self.class.new(StaticArray[
        a, -b, c, d,
        e, -f, g, h,
        i, -j, k, l,
        m, n, o, p,
      ])
    end

    # Returns a matrix that has a reflection transform applied.
    #
    # Multiplying a 3D object by this matrix will reflect it along the z-axis.
    #
    # ```
    # vector = Vector4[1, 2, 3, 1]
    # matrix = Matrix4(Int32).identity.reflect_x
    # vector * matrix # => (1, 2, -3, 1)
    # ```
    def reflect_z : self
      self.class.new(StaticArray[
        a, b, -c, d,
        e, f, -g, h,
        i, j, -k, l,
        m, n, o, p,
      ])
    end

    # Returns a matrix that has a shear transform applied.
    #
    # Multiplying a 3D object by this matrix
    # will shear it along the y and z-axis based on the x-axis.
    # For each unit along the x-axis, the y value will be adjusted by *y*
    # and the z value will be adjusted by *z*.
    #
    # ```
    # vector = Vector4[2, 3, 4, 1]
    # matrix = Matrix4(Int32).identity.shear_x(2, 3)
    # vector * matrix # => (2, 7, 10, 1, 1)
    # ```
    def shear_x(y, z) : CommonMatrix
      {{@type.name(generic_args: false)}}.new(StaticArray[
        a, a * y + b, a * z + c, d,
        e, e * y + f, e * z + g, h,
        i, i * y + j, i * z + k, l,
        m, n, o, p,
      ])
    end

    # Returns a matrix that has a shear transform applied.
    #
    # Multiplying a 3D object by this matrix
    # will shear it along the x and z-axis based on the y-axis.
    # For each unit along the y-axis, the x value will be adjusted by *x*
    # and the z value will be adjusted by *z*.
    #
    # ```
    # vector = Vector4[2, 3, 4, 1]
    # matrix = Matrix4(Int32).identity.shear_y(2, 3)
    # vector * matrix # => (8, 3, 13, 1)
    # ```
    def shear_y(x, z) : CommonMatrix
      {{@type.name(generic_args: false)}}.new(StaticArray[
        a + b * x, b, b * z + c, d,
        e + f * x, f, f * z + g, h,
        i + j * x, j, j * z + k, l,
        m, n, o, p,
      ])
    end

    # Returns a matrix that has a shear transform applied.
    #
    # Multiplying a 3D object by this matrix
    # will shear it along the x and y-axis based on the z-axis.
    # For each unit along the z-axis, the x value will be adjusted by *x*
    # and the y value will be adjusted by *y*.
    #
    # ```
    # vector = Vector4[2, 3, 4, 1]
    # matrix = Matrix4(Int32).identity.shear_z(2, 3)
    # vector * matrix # => (10, 15, 4, 1)
    # ```
    def shear_z(x, y) : CommonMatrix
      {{@type.name(generic_args: false)}}.new(StaticArray[
        a + c * x, b + c * y, c, d,
        e + g * x, f + g * y, g, h,
        i + k * x, j + k * y, k, l,
        m, n, o, p,
      ])
    end

    # Returns a matrix with a translation applied.
    #
    # ```
    # vector = Vector4[3, 5, 7, 1]
    # matrix = Matrix4(Int32).identity.translate(3, 2, 1)
    # vector * matrix # => (6, 7, 8, 1)
    # ```
    def translate(x, y, z) : CommonMatrix
      {{@type.name(generic_args: false)}}.new(StaticArray[
        a, b, c, d,
        e, f, g, h,
        i, j, k, l,
        m + x, n + y, o + z, p,
      ])
    end
  end
end
