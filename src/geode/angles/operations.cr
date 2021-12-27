module Geode
  abstract struct Angle(T)
    # Returns the absolute value of the angle.
    #
    # ```
    # -45.degrees.abs # => 45°
    # ```
    def abs : self
      self.class.new(value.abs)
    end

    # Returns the angle squared.
    #
    # ```
    # 5.degrees.abs2 # => 25°
    # ```
    def abs2 : self
      self.class.new(value.abs2)
    end

    # Returns an angle corrected to be between zero and one revolution.
    #
    # ```
    # 30.degrees.normalize  # => 30°
    # -90.degrees.normalize # => 270°
    # 360.degrees.normalize # => 0°
    # 540.degrees.normalize # => 180°
    # ```
    def normalize : self
      full = self.class.full.value
      value = (self.value + full) % full
      self.class.new(value)
    end

    # Returns an angle corrected to be between negative half a revolution to positive half a revolution.
    #
    # ```
    # 30.degrees.normalize   # => 30°
    # -45.degrees.normalize  # => -45°
    # 360.degrees.normalize  # => 0°
    # 270.degrees.normalize  # => -90°
    # -225.degrees.normalize # => 135°
    # ```
    def signed_normalize : self
      half = self.class.half.value
      full = self.class.full.value
      value = (self.value + half) % full - half
      self.class.new(T.new(value))
    end

    # Returns a rounded angle.
    #
    # See `Number#round` for details.
    #
    # ```
    # 90.1.degrees.round # => 90.0°
    # ```
    def round(mode : Number::RoundingMode = :ties_even) : self
      self.class.new(value.round(mode))
    end

    # Returns a rounded angle.
    #
    # See `Number#round` for details.
    #
    # ```
    # 12.34.degrees.round(1) # => 12.3°
    # ```
    def round(digits : Number, base = 10, *, mode : Number::RoundingMode = :ties_even) : self
      self.class.new(value.round(digits, base, mode: mode))
    end

    # Returns a value equal to its original sign.
    #
    # 1 is used for positive values, -1 for negative values, and 0 for zero.
    #
    # ```
    # -5.degrees.sign # => -1
    # ```
    def sign
      value.sign
    end

    # Returns an angle rounded up to the nearest integer.
    #
    # ```
    # 25.3.degrees.ceil # => 26.0°
    # ```
    def ceil : self
      self.class.new(value.ceil)
    end

    # Returns an angle rounded down to the nearest integer.
    #
    # ```
    # 5.7.degrees.floor # => 5.0°
    # ```
    def floor : self
      self.class.new(value.floor)
    end

    # Returns the fraction portion of the angle's value.
    #
    # This is effectively equal to:
    #
    # ```text
    # fraction(v) = v - floor(v)
    # ```
    #
    # ```
    # 1.2.degrees.fraction # => 0.2°
    # ```
    def fraction : self
      self - floor
    end

    # Calculates the linear interpolation between two angles.
    #
    # *t* is a value from 0 to 1, where 0 represents this angle and 1 represents *other*.
    # Any value between 0 and 1 will result in a proportional amount of this angle and *other*.
    #
    # This method uses the precise calculation
    # that does not suffer precision loss from high exponential differences.
    def lerp(other : self, t : Number) : self
      value = Geode.lerp(self.value, other.value, t)
      self.class.new(T.new(value))
    end

    # Returns a negated angle.
    #
    # ```
    # -(45.degrees) # => -45°
    # ```
    def - : self
      self.class.new(-value)
    end

    # Adds two angles together.
    #
    # ```
    # 30.degrees + 45.degrees # => 75°
    # ```
    def +(other : self) : self
      self.class.new(value + other.value)
    end

    # Adds two angles of different types together.
    #
    # ```
    # 30.degrees + Math::PI.radians / 2 # => 120.0°
    # ```
    def +(other : Angle) : Angle
      value = self.value + {{@type.name(generic_args: false)}}.new(other).value
      {{@type.name(generic_args: false)}}.new(value)
    end

    # Subtracts another angle from this one.
    #
    # ```
    # 90.degrees - 30.degrees # => 60°
    # ```
    def -(other : self) : self
      self.class.new(value - other.value)
    end

    # Subtracts another angle of a different type from this one.
    #
    # ```
    # 180.degrees - Math::PI.radians / 2 # => 90.0°
    # ```
    def -(other : Angle) : Angle
      value = self.value - {{@type.name(generic_args: false)}}.new(other).value
      {{@type.name(generic_args: false)}}.new(value)
    end

    # Multiplies the angle by the specified amount.
    #
    # ```
    # 15.degrees * 5 # => 75°
    # ```
    def *(amount : Number) : Angle
      {{@type.name(generic_args: false)}}.new(value * amount)
    end

    # Divides the angle by the specified amount.
    #
    # ```
    # 90.degrees / 4 # => 22.5°
    # ```
    def /(amount : Number) : Angle
      {{@type.name(generic_args: false)}}.new(value / amount)
    end

    # Divides the angle by another.
    #
    # ```
    # 180.degrees / 45.degrees # => 4.0
    # ```
    def /(other : self) : Number
      value / other.value
    end

    # Divides the angle by another of a different type.
    #
    # ```
    # 180.degrees / (Math::PI.radians / 3) # => 3.0
    # ```
    def /(other : Angle) : Number
      value / {{@type.name(generic_args: false)}}.new(other).value
    end

    # Divides the angle by the specified amount.
    #
    # Uses integer division.
    #
    # ```
    # 25.degrees // 10 # => 2°
    # ```
    def //(amount : Number) : Angle
      {{@type.name(generic_args: false)}}.new(value // amount)
    end

    # Divides the angle by another.
    #
    # Uses integer division.
    #
    # ```
    # 30.degrees // 4.degrees # => 7
    # ```
    def //(other : self) : Number
      value // other.value
    end

    # Divides the angle by another of a different type.
    #
    # Uses integer division.
    #
    # ```
    # 200.degrees // (Math::PI.radians / 3) # => 3
    # ```
    def //(other : Angle) : Number
      value // {{@type.name(generic_args: false)}}.new(other).value
    end

    # Computes the remainder after dividing the angle by the specified amount.
    #
    # ```
    # 25.degrees % 10 # => 5°
    # ```
    def %(amount : Number) : Angle
      {{@type.name(generic_args: false)}}.new(value % amount)
    end

    # Computes the remainder after dividing the angle by another.
    #
    # ```
    # 30.degrees % 4.degrees # => 2
    # ```
    def %(other : self) : Number
      value % other.value
    end

    # Computes the remainder after dividing the angle by another of a different type.
    #
    # ```
    # 200.degrees % (Math::PI.radians / 3) # => 20
    # ```
    def %(other : Angle) : Number
      value % {{@type.name(generic_args: false)}}.new(other).value
    end
  end
end
