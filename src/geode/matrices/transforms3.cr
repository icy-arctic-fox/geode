module Geode
  # Transformation that can be performed in three-dimensions with matrices.
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
  module MatrixTransformConstructors3(T)
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

    # Creates a 2D transform matrix with space for translation.
    #
    # ```
    # vector = Vector3[3, 5, 1]
    # matrix = Matrix3(Int32).translate(1, 2)
    # vector * matrix # => (4, 7, 1)
    # ```
    def translate(x : T, y : T) : self
      new(StaticArray[
        T.multiplicative_identity, T.zero, T.zero,
        T.zero, T.multiplicative_identity, T.zero,
        x, y, T.multiplicative_identity,
      ])
    end

    # Creates a 2D rotation matrix with space for translation.
    #
    # Multiplying an object by this matrix will rotate it the specified amount.
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # vector = Vector3[3 / 5, 4 / 5, 1.0]
    # matrix = Matrix3(Float64).rotate(90.degrees)
    # vector * matrix # => (-0.8, 0.6, 1.0)
    # ```
    def rotate(angle : Number | Angle) : self
      rad = angle.to_f
      sin = T.new(Math.sin(rad))
      cos = T.new(Math.cos(rad))

      new(StaticArray[
        cos, sin, T.zero,
        -sin, cos, T.zero,
        T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 2D 90-degree rotation matrix with space for translation.
    #
    # Multiplying an object by this matrix will rotate it 90 degrees.
    #
    # ```
    # vector = Vector3[1, 1, 1]
    # matrix = Matrix3(Int32).rotate90
    # vector * matrix # => (-1, 1, 1)
    # ```
    def rotate90 : self
      new(StaticArray[
        T.zero, T.multiplicative_identity, T.zero,
        -T.multiplicative_identity, T.zero, T.zero,
        T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 2D 180-degree rotation matrix with space for translation.
    #
    # Multiplying an object by this matrix will rotate it 180 degrees.
    #
    # ```
    # vector = Vector3[1, 1, 1]
    # matrix = Matrix3(Int32).rotate180
    # vector * matrix # => (-1, -1, 1)
    # ```
    def rotate180 : self
      new(StaticArray[
        -T.multiplicative_identity, T.zero, T.zero,
        T.zero, -T.multiplicative_identity, T.zero,
        T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 2D 270-degree rotation matrix with space for translation.
    #
    # Multiplying an object by this matrix will rotate it 270 degrees.
    #
    # ```
    # vector = Vector3[1, 1, 1]
    # matrix = Matrix3(Int32).rotate270
    # vector * matrix # => (1, 1, 1)
    # ```
    #
    # See: `#reflect_xy`
    def rotate270 : self
      new(StaticArray[
        T.zero, -T.multiplicative_identity, T.zero,
        T.multiplicative_identity, T.zero, T.zero,
        T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 2D scaling matrix with space for translation.
    #
    # Uniformly scales an object.
    # Multiplying an object by this matrix will scale it by *amount*.
    # Values for *amount* smaller than 1 will shrink it.
    # Values larger than 1 will enlarge it.
    # Negative values will flip it.
    #
    # ```
    # vector = Vector3[2, 3, 1]
    # matrix = Matrix3(Int32).scale2(2)
    # vector * matrix # => (4, 6, 1)
    # ```
    def scale2(amount : T) : self
      new(StaticArray[
        amount, T.zero, T.zero,
        T.zero, amount, T.zero,
        T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 2D scaling matrix with space for translation.
    #
    # Non-uniformly scales an object (squash and stretch).
    # Multiplying an object by this matrix will scale it by *x* amount along the x-axis and *y* amount along the y-axis.
    # Values for *x* and *y* smaller than 1 will shrink it.
    # Values larger than 1 will enlarge it.
    # Negative values will flip it.
    #
    # ```
    # vector = Vector3[2, 3, 1]
    # matrix = Matrix3(Float64).scale(1.5, 2)
    # vector * matrix # => (3.0, 6.0, 1.0)
    # ```
    def scale(x : T, y : T) : self
      new(StaticArray[
        x, T.zero, T.zero,
        T.zero, y, T.zero,
        T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 2D reflecting matrix with space for translation.
    #
    # Multiplying an object by this matrix will reflect it along the x-axis.
    #
    # ```
    # vector = Vector3[5, 1, 1]
    # matrix = Matrix3(Int32).reflect_x
    # vector * matrix # => (-5, 1, 1)
    # ```
    def reflect_x : self
      new(StaticArray[
        -T.multiplicative_identity, T.zero, T.zero,
        T.zero, T.multiplicative_identity, T.zero,
        T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 2D reflective matrix with space for translation.
    #
    # Multiplying an object by this matrix will reflect it along the y-axis.
    #
    # ```
    # vector = Vector3[5, 1, 1]
    # matrix = Matrix3(Int32).reflect_y
    # vector * matrix # => (5, -1, 1)
    # ```
    def reflect_y : self
      new(StaticArray[
        T.multiplicative_identity, T.zero, T.zero,
        T.zero, -T.multiplicative_identity, T.zero,
        T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 2D reflective matrix with space for translation.
    #
    # Multiplying an object by this matrix will reflect it along the x and y-axis.
    # This has the same effect as rotating 180 degrees.
    #
    # ```
    # vector = Vector3[5, 1, 1]
    # matrix = Matrix3(Int32).reflect_xy
    # vector * matrix # => (-5, -1, 1)
    # ```
    #
    # See: `#rotate270`
    def reflect_xy : self
      new(StaticArray[
        -T.multiplicative_identity, T.zero, T.zero,
        T.zero, -T.multiplicative_identity, T.zero,
        T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 2D shearing matrix with space for translation.
    #
    # Multiplying an object by this matrix will shear it along the x-axis.
    #
    # ```
    # vector = Vector3[2, 3, 1]
    # matrix = Matrix3(Int32).shear_x(2)
    # vector * matrix # => (8, 3, 1)
    # ```
    def shear_x(amount : T) : self
      new(StaticArray[
        T.multiplicative_identity, T.zero, T.zero,
        amount, T.multiplicative_identity, T.zero,
        T.zero, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 2D shearing matrix with space for translation.
    #
    # Multiplying an object by this matrix will shear it along the y-axis.
    #
    # ```
    # vector = Vector3[2, 3, 1]
    # matrix = Matrix3(Int32).shear_y(2)
    # vector * matrix # => (2, 7, 1)
    # ```
    def shear_y(amount : T) : self
      new(StaticArray[
        T.multiplicative_identity, amount, T.zero,
        T.zero, T.multiplicative_identity, T.zero,
        T.zero, T.zero, T.multiplicative_identity,
      ])
    end
  end

  # Transformation that can be performed in two-dimensions with matrices.
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
  module MatrixTransforms3(T)
    # Returns a matrix that has a 2D rotation transform applied.
    #
    # Returns a 3x3 matrix.
    # The *angle* must be a `Number` in radians or an `Angle`.
    #
    # ```
    # vector = Vector3[3 / 5, 4 / 5, 1]
    # matrix = Matrix3(Float64).identity.rotate(45.degrees)
    # vector * matrix # => (0.0, 1.0, 1.0)
    # ```
    def rotate(angle : Number | Angle) : CommonMatrix
      rad = angle.to_f
      sin = Math.sin(rad)
      cos = Math.cos(rad)

      {{@type.name(generic_args: false)}}.new(StaticArray[
        a * cos + b * -sin, a * sin + b * cos, c,
        d * cos + e * -sin, d * sin + e * cos, f,
        g, h, i,
      ])
    end

    # Returns a matrix that has a 90-degree rotation transform applied.
    #
    # Returns a 3x3 matrix.
    # Multiplying a 2D object by this matrix will rotate it 90 degrees.
    #
    # ```
    # vector = Vector3[1, 1, 1]
    # matrix = Matrix3(Int32).identity.rotate90
    # vector * matrix # => (-1, 1, 1)
    # ```
    def rotate90 : self
      self.class.new(StaticArray[
        -b, a, c,
        -e, d, f,
        g, h, i,
      ])
    end

    # Returns a matrix that has a 180-degree rotation transform applied.
    #
    # Returns a 3x3 matrix.
    # Multiplying a 2D object by this matrix will rotate it 180 degrees.
    #
    # ```
    # vector = Vector3[1, 1, 1]
    # matrix = Matrix3(Int32).identity.rotate180
    # vector * matrix # => (-1, -1, 1)
    # ```
    def rotate180 : self
      self.class.new(StaticArray[
        -a, -b, c,
        -d, -e, f,
        g, h, i,
      ])
    end

    # Returns a matrix that has a 270-degree rotation transform applied.
    #
    # Returns a 3x3 matrix.
    # Multiplying a 2D object by this matrix will rotate it 270 degrees.
    #
    # ```
    # vector = Vector3[1, 1, 1]
    # matrix = Matrix3(Int32).identity.rotate270
    # vector * matrix # => (-1, -1, 1)
    # ```
    #
    # See: `#reflect_xy`
    def rotate270 : self
      self.class.new(StaticArray[
        b, -a, c,
        e, -d, f,
        g, h, i,
      ])
    end

    # Returns a matrix that has a scale transform applied.
    #
    # Returns a 3x3 matrix.
    #
    # Uniformly scales an object.
    # Multiplying a 2D object by this matrix will scale it by *amount*.
    # Values for *amount* smaller than 1 will shrink it.
    # Values larger than 1 will enlarge it.
    # Negative values will flip it.
    #
    # ```
    # vector = Vector3[2, 3, 1]
    # matrix = Matrix3(Int32).identity.scale2(2)
    # vector * matrix # => (4, 6, 1)
    # ```
    def scale2(amount : Number) : CommonMatrix
      {{@type.name(generic_args: false)}}.new(StaticArray[
        a * amount, b * amount, c,
        d * amount, e * amount, f,
        g, h, i,
      ])
    end

    # Returns a matrix that has a scale transform applied.
    #
    # Returns a 3x3 matrix.
    #
    # Non-uniformly scales an object (squash and stretch).
    # Values for *x* and *y* smaller than 1 will shrink it.
    # Values larger than 1 will enlarge it.
    # Negative values will flip it.
    #
    # ```
    # vector = Vector3[2, 3, 1]
    # matrix = Matrix3(Float64).identity.scale(1.5, 2)
    # vector * matrix # => (3.0, 6.0, 1.0)
    # ```
    def scale(x, y) : CommonMatrix
      {{@type.name(generic_args: false)}}.new(StaticArray[
        a * x, b * y, c,
        d * x, e * y, f,
        g, h, i,
      ])
    end

    # Returns a matrix that has a reflection transform applied.
    #
    # Returns a 3x3 matrix.
    # Multiplying a 2D object by this matrix will reflect it along the x-axis.
    #
    # ```
    # vector = Vector3[5, 1, 1]
    # matrix = Matrix3(Int32).identity.reflect_x
    # vector * matrix # => (-5, 1, 1)
    # ```
    def reflect_x : self
      self.class.new(StaticArray[
        -a, b, c,
        -d, e, f,
        g, h, i,
      ])
    end

    # Returns a matrix that has a scale transform applied.
    #
    # Returns a 3x3 matrix.
    # Multiplying a 2D object by this matrix will reflect it along the y-axis.
    #
    # ```
    # vector = Vector3[5, 1, 1]
    # matrix = Matrix3(Int32).identity.reflect_y
    # vector * matrix # => (5, -1, 1)
    # ```
    def reflect_y : self
      self.class.new(StaticArray[
        a, -b, c,
        d, -e, f,
        g, h, i,
      ])
    end

    # Returns a matrix that has a scale transform applied.
    #
    # Returns a 3x3 matrix.
    # Multiplying a 2D object by this matrix will reflect it along the x and y-axis.
    # This has the same effect as rotating 180 degrees.
    #
    # ```
    # vector = Vector3[5, 1, 1]
    # matrix = Matrix3(Int32).identity.reflect_xy
    # vector * matrix # => (-5, -1, 1)
    # ```
    #
    # See: `#rotate270`
    def reflect_xy : self
      self.class.new(StaticArray[
        -a, -b, c,
        -d, -e, f,
        g, h, i,
      ])
    end

    # Returns a matrix that has a shear transform applied.
    #
    # Returns a 3x3 matrix.
    # Multiplying a 2D object by this matrix will shear it along the x-axis.
    #
    # ```
    # vector = Vector3[2, 3, 1]
    # matrix = Matrix3(Int32).identity.shear_x(2)
    # vector * matrix # => (8, 3, 1)
    # ```
    def shear_x(amount) : CommonMatrix
      {{@type.name(generic_args: false)}}.new(StaticArray[
        a + b * amount, b, c,
        d + e * amount, e, f,
        g, h, i,
      ])
    end

    # Returns a matrix that has a shear transform applied.
    #
    # Returns a 3x3 matrix.
    # Multiplying a 2D object by this matrix will shear it along the y-axis.
    #
    # ```
    # vector = Vector3[2, 3, 1]
    # matrix = Matrix3(Int32).identity.shear_y(2)
    # vector * matrix # => (2, 7, 1)
    # ```
    def shear_y(amount : T) : self
      {{@type.name(generic_args: false)}}.new(StaticArray[
        a, a * amount + b, c,
        d, d * amount + e, f,
        g, h, i,
      ])
    end

    # Returns a matrix that has a translation applied.
    #
    # Returns a 3x3 matrix.
    #
    # ```
    # vector = Vector3[3, 5, 1]
    # matrix = Matrix3(Int32).identity.translate(1, 2)
    # vector * matrix # => (4, 7, 1)
    # ```
    def translate(x, y) : CommonMatrix
      Matrix3x3.new(StaticArray[
        a, b, c,
        d, e, f,
        g + x, h + y, i,
      ])
    end
  end
end
