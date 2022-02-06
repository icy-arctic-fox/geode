module Geode
  # Provides methods to construct 4x4 projection matrices.
  #
  # A note about notation:
  # `rh` means righ-handed and `lh` means left-handed.
  # These indicate whether the matrix will be generated for right or left-handed coordinate systems.
  # `no` means "negative one to one" and `zo` means "zero to one".
  # This indicates whether the z-coordinate will be normalized to `(-1..1)` or `(0..1)` respectively.
  #
  # If a 3D method does not have either of these tokens, then the method uses the default configuration.
  # The default configuration is controlled by compiler flags.
  # Right-handed orientation with normalization between -1 and 1 is the default (common in OpenGL).
  # Specify `-Dleft_handed` to use a left-handed system.
  # Specify `-Dz_zero_one` to normalize z-coordinates to between 0 and 1.
  #
  # This module should be extended.
  module MatrixProjections(T)
    # Creates a 2D orthographic projection matrix.
    #
    # ```
    # Matrix4F.ortho(-400, 400, -300, 300)
    # ```
    def ortho(left : T, right : T, bottom : T, top : T) : self
      dx = right - left
      dy = top - bottom

      sx = T.new(2) / dx
      sy = T.new(2) / dy
      sz = -T.multiplicative_identity

      tx = -(right + left) / dx
      ty = -(top + bottom) / dy

      new(StaticArray[
        sx, T.zero, T.zero, T.zero,
        T.zero, sy, T.zero, T.zero,
        T.zero, T.zero, sz, T.zero,
        tx, ty, T.zero, T.multiplicative_identity,
      ])
    end

    # Creates a 3D orthographic projection matrix.
    #
    # Each argument is the distance to its respective clip plane.
    # *left* and *right* represent the distance along the x-axis,
    # *bottom* and *top* along the y-axis,
    # and *near* and *far* along the z-axis.
    #
    # The matrix produced is for right-handed systems.
    # The z-coordinate is normalized to the range -1 to 1.
    #
    # ```
    # Matrix4F.ortho_rh_no(-400, 400, -300, 300, 0.1, 100)
    # ```
    def ortho_rh_no(left : T, right : T, bottom : T, top : T, near : T, far : T) : self
      dx = right - left
      dy = top - bottom
      dz = far - near

      sx = T.new(2) / dx
      sy = T.new(2) / dy
      sz = T.new(-2) / dz

      tx = -(right + left) / dx
      ty = -(top + bottom) / dy
      tz = -(far + near) / dz

      new(StaticArray[
        sx, T.zero, T.zero, T.zero,
        T.zero, sy, T.zero, T.zero,
        T.zero, T.zero, sz, T.zero,
        tx, ty, tz, T.multiplicative_identity,
      ])
    end

    # Creates a 3D orthographic projection matrix.
    #
    # Each argument is the distance to its respective clip plane.
    # *left* and *right* represent the distance along the x-axis,
    # *bottom* and *top* along the y-axis,
    # and *near* and *far* along the z-axis.
    #
    # The matrix produced is for right-handed systems.
    # The z-coordinate is normalized to the range 0 to 1.
    #
    # ```
    # Matrix4F.ortho_rh_zo(-400, 400, -300, 300, 0.1, 100)
    # ```
    def ortho_rh_zo(left : T, right : T, bottom : T, top : T, near : T, far : T) : self
      dx = right - left
      dy = top - bottom
      dz = far - near

      sx = T.new(2) / dx
      sy = T.new(2) / dy
      sz = T.new(-1) / dz

      tx = -(right + left) / dx
      ty = -(top + bottom) / dy
      tz = -near / dz

      new(StaticArray[
        sx, T.zero, T.zero, T.zero,
        T.zero, sy, T.zero, T.zero,
        T.zero, T.zero, sz, T.zero,
        tx, ty, tz, T.multiplicative_identity,
      ])
    end

    # Creates a 3D orthographic projection matrix.
    #
    # Each argument is the distance to its respective clip plane.
    # *left* and *right* represent the distance along the x-axis,
    # *bottom* and *top* along the y-axis,
    # and *near* and *far* along the z-axis.
    #
    # The matrix produced is for left-handed systems.
    # The z-coordinate is normalized to the range -1 to 1.
    #
    # ```
    # Matrix4F.ortho_lh_no(-400, 400, -300, 300, 0.1, 100)
    # ```
    def ortho_lh_no(left : T, right : T, bottom : T, top : T, near : T, far : T) : self
      dx = right - left
      dy = top - bottom
      dz = far - near

      sx = T.new(2) / dx
      sy = T.new(2) / dy
      sz = T.new(2) / dz

      tx = -(right + left) / dx
      ty = -(top + bottom) / dy
      tz = -(far + near) / dz

      new(StaticArray[
        sx, T.zero, T.zero, T.zero,
        T.zero, sy, T.zero, T.zero,
        T.zero, T.zero, sz, T.zero,
        tx, ty, tz, T.multiplicative_identity,
      ])
    end

    # Creates a 3D orthographic projection matrix.
    #
    # Each argument is the distance to its respective clip plane.
    # *left* and *right* represent the distance along the x-axis,
    # *bottom* and *top* along the y-axis,
    # and *near* and *far* along the z-axis.
    #
    # The matrix produced is for left-handed systems.
    # The z-coordinate is normalized to the range 0 to 1.
    #
    # ```
    # Matrix4F.ortho_lh_zo(-400, 400, -300, 300, 0.1, 100)
    # ```
    def ortho_lh_zo(left : T, right : T, bottom : T, top : T, near : T, far : T) : self
      dx = right - left
      dy = top - bottom
      dz = far - near

      sx = T.new(2) / dx
      sy = T.new(2) / dy
      sz = T.new(1) / dz

      tx = -(right + left) / dx
      ty = -(top + bottom) / dy
      tz = -near / dz

      new(StaticArray[
        sx, T.zero, T.zero, T.zero,
        T.zero, sy, T.zero, T.zero,
        T.zero, T.zero, sz, T.zero,
        tx, ty, tz, T.multiplicative_identity,
      ])
    end

    # Creates a 3D orthographic projection matrix.
    #
    # Each argument is the distance to its respective clip plane.
    # *left* and *right* represent the distance along the x-axis,
    # *bottom* and *top* along the y-axis,
    # and *near* and *far* along the z-axis.
    #
    # The handedness and z-coordinate normalization are controlled by compiler flags.
    # Right-handed orientation with normalization between -1 and 1 is the default (common in OpenGL).
    # Specify `-Dleft_handed` to use a left-handed system.
    # Specify `-Dz_zero_one` to normalize z-coordinates to between 0 and 1.
    #
    # ```
    # Matrix4F.ortho(-400, 400, -300, 300, 0.1, 100)
    # ```
    @[AlwaysInline]
    def ortho(left : T, right : T, bottom : T, top : T, near : T, far : T) : self
      {% if flag?(:left_handed) %}
        {% if flag?(:z_zero_one) %}
          ortho_lh_zo(left, right, bottom, top, near, far)
        {% else %}
          ortho_lh_no(left, right, bottom, top, near, far)
        {% end %}
      {% else %}
        {% if flag?(:z_zero_one) %}
          ortho_rh_zo(left, right, bottom, top, near, far)
        {% else %}
          ortho_rh_no(left, right, bottom, top, near, far)
        {% end %}
      {% end %}
    end

    # Creates a 3D perspective projection matrix.
    #
    # *fov* is the **vertical** field-of-view.
    # It must be a `Number` in radians or an `Angle` (any unit).
    # The *aspect* defines the ratio of width to height.
    # For instance, if the display is 16:9, then *aspect* should be `16 / 9`.
    # Alternatively, just provide the screen width divided by the height (`1920 / 1080`).
    #
    # The *near* and *far* arguments control the normalization of z-coordinates.
    # *far* is the distance to the far clip plane and *near* is the distance to the near clip plane.
    #
    # The matrix produced is for right-handed systems.
    # The z-coordinate is normalized to the range -1 to 1.
    #
    # ```
    # Matrix4F.perspective_rh_no(90.degrees, 800 / 600, 0.1, 100)
    # ```
    def perspective_rh_no(fov : Number | Angle, aspect : T, near : T, far : T) : self
      tan = T.new(Math.tan(fov.to_f / T.new(2)))

      x = T.multiplicative_identity / (tan * aspect)
      y = T.multiplicative_identity / tan
      z = -(far + near) / (far - near)

      zw = -T.multiplicative_identity
      wz = -(T.new(2) * far * near) / (far - near)

      new(StaticArray[
        x, T.zero, T.zero, T.zero,
        T.zero, y, T.zero, T.zero,
        T.zero, T.zero, z, zw,
        T.zero, T.zero, wz, T.zero,
      ])
    end

    # Creates a 3D perspective projection matrix.
    #
    # *fov* is the **vertical** field-of-view.
    # It must be a `Number` in radians or an `Angle` (any unit).
    # The *aspect* defines the ratio of width to height.
    # For instance, if the display is 16:9, then *aspect* should be `16 / 9`.
    # Alternatively, just provide the screen width divided by the height (`1920 / 1080`).
    #
    # The *near* and *far* arguments control the normalization of z-coordinates.
    # *far* is the distance to the far clip plane and *near* is the distance to the near clip plane.
    #
    # The matrix produced is for right-handed systems.
    # The z-coordinate is normalized to the range 0 to 1.
    #
    # ```
    # Matrix4F.perspective_rh_zo(90.degrees, 800 / 600, 0.1, 100)
    # ```
    def perspective_rh_zo(fov : Number | Angle, aspect : T, near : T, far : T) : self
      tan = T.new(Math.tan(fov.to_f / T.new(2)))

      x = T.multiplicative_identity / (tan * aspect)
      y = T.multiplicative_identity / tan
      z = far / (near - far)

      zw = -T.multiplicative_identity
      wz = -(far * near) / (far - near)

      new(StaticArray[
        x, T.zero, T.zero, T.zero,
        T.zero, y, T.zero, T.zero,
        T.zero, T.zero, z, zw,
        T.zero, T.zero, wz, T.zero,
      ])
    end

    # Creates a 3D perspective projection matrix.
    #
    # *fov* is the **vertical** field-of-view.
    # It must be a `Number` in radians or an `Angle` (any unit).
    # The *aspect* defines the ratio of width to height.
    # For instance, if the display is 16:9, then *aspect* should be `16 / 9`.
    # Alternatively, just provide the screen width divided by the height (`1920 / 1080`).
    #
    # The *near* and *far* arguments control the normalization of z-coordinates.
    # *far* is the distance to the far clip plane and *near* is the distance to the near clip plane.
    #
    # The matrix produced is for left-handed systems.
    # The z-coordinate is normalized to the range -1 to 1.
    #
    # ```
    # Matrix4F.perspective_lh_no(90.degrees, 800 / 600, 0.1, 100)
    # ```
    def perspective_lh_no(fov : Number | Angle, aspect : T, near : T, far : T) : self
      tan = T.new(Math.tan(fov.to_f / T.new(2)))

      x = T.multiplicative_identity / (tan * aspect)
      y = T.multiplicative_identity / tan
      z = (far + near) / (far - near)

      zw = T.multiplicative_identity
      wz = -(T.new(2) * far * near) / (far - near)

      new(StaticArray[
        x, T.zero, T.zero, T.zero,
        T.zero, y, T.zero, T.zero,
        T.zero, T.zero, z, zw,
        T.zero, T.zero, wz, T.zero,
      ])
    end

    # Creates a 3D perspective projection matrix.
    #
    # *fov* is the **vertical** field-of-view.
    # It must be a `Number` in radians or an `Angle` (any unit).
    # The *aspect* defines the ratio of width to height.
    # For instance, if the display is 16:9, then *aspect* should be `16 / 9`.
    # Alternatively, just provide the screen width divided by the height (`1920 / 1080`).
    #
    # The *near* and *far* arguments control the normalization of z-coordinates.
    # *far* is the distance to the far clip plane and *near* is the distance to the near clip plane.
    #
    # The matrix produced is for left-handed systems.
    # The z-coordinate is normalized to the range 0 to 1.
    #
    # ```
    # Matrix4F.perspective_lh_zo(90.degrees, 800 / 600, 0.1, 100)
    # ```
    def perspective_lh_zo(fov : Number | Angle, aspect : T, near : T, far : T) : self
      tan = T.new(Math.tan(fov.to_f / T.new(2)))

      x = T.multiplicative_identity / (tan * aspect)
      y = T.multiplicative_identity / tan
      z = far / (far - near)

      zw = T.multiplicative_identity
      wz = -(far * near) / (far - near)

      new(StaticArray[
        x, T.zero, T.zero, T.zero,
        T.zero, y, T.zero, T.zero,
        T.zero, T.zero, z, zw,
        T.zero, T.zero, wz, T.zero,
      ])
    end

    # Creates a 3D perspective projection matrix.
    #
    # *fov* is the **vertical** field-of-view.
    # It must be a `Number` in radians or an `Angle` (any unit).
    # The *aspect* defines the ratio of width to height.
    # For instance, if the display is 16:9, then *aspect* should be `16 / 9`.
    # Alternatively, just provide the screen width divided by the height (`1920 / 1080`).
    #
    # The *near* and *far* arguments control the normalization of z-coordinates.
    # *far* is the distance to the far clip plane and *near* is the distance to the near clip plane.
    #
    # The handedness and z-coordinate normalization are controlled by compiler flags.
    # Right-handed orientation with normalization between -1 and 1 is the default (common in OpenGL).
    # Specify `-Dleft_handed` to use a left-handed system.
    # Specify `-Dz_zero_one` to normalize z-coordinates to between 0 and 1.
    #
    # ```
    # Matrix4F.perspective(90.degrees, 800 / 600, 0.1, 100)
    # ```
    @[AlwaysInline]
    def perspective(fov : Number | Angle, aspect : T, near : T, far : T) : self
      {% if flag?(:left_handed) %}
        {% if flag?(:z_zero_one) %}
          perspective_lh_zo(fov, aspect, near, far)
        {% else %}
          perspective_lh_no(fov, aspect, near, far)
        {% end %}
      {% else %}
        {% if flag?(:z_zero_one) %}
          perspective_rh_zo(fov, aspect, near, far)
        {% else %}
          perspective_rh_no(fov, aspect, near, far)
        {% end %}
      {% end %}
    end
  end
end
