module Geode
  module MatrixProjections(T)
    def ortho(left : T, right : T, bottom : T, top : T, near : T, far : T) : self
      sx = T.new(2) / (right - left)
      sy = T.new(2) / (top - bottom)
      sz = T.new(-2) / (far - near)

      tx = -(right + left) / (right - left)
      ty = -(top + bottom) / (top - bottom)
      tz = -(far + near) / (far - near)

      new(StaticArray[
        sx, T.zero, T.zero, T.zero,
        T.zero, sy, T.zero, T.zero,
        T.zero, T.zero, sz, T.zero,
        tx, ty, tz, T.multiplicative_identity,
      ])
    end

    def perspective(fov : Number | Angle, aspect : T, near : T, far : T) : self
      tan = T.new(Math.tan(fov.to_f / T.new(2)))

      x = T.new(1) / (tan * aspect)
      y = T.new(1) / tan
      z = far / (near - far)

      zw = T.new(-1)
      wz = -(far * near) / (far - near)

      new(StaticArray[
        x, T.zero, T.zero, T.zero,
        T.zero, y, T.zero, T.zero,
        T.zero, T.zero, z, zw,
        T.zero, T.zero, wz, T.zero,
      ])
    end
  end
end
