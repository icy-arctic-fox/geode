module Geode
  abstract struct Angle(T)
    include Comparable(Angle)

    # Compares this angle to another.
    #
    # The return value will be:
    # - -1 if this angle is less than *other*.
    # - 0 if the angles are equal.
    # - 1 if this angle is greater than *other*.
    #
    # ```
    # 45.degrees <=> 90.degrees # => -1
    # 60.degrees <=> 60.degrees # => 0
    # 90.degrees <=> 45.degrees # => 1
    # ```
    def <=>(other : self)
      value <=> other.value
    end

    # Compares this angle to another of a different type.
    #
    # The return value will be:
    # - -1 if this angle is less than *other*.
    # - 0 if the angles are equal.
    # - 1 if this angle is greater than *other*.
    #
    # ```
    # 45.degrees <=> (Math::PI).radians     # => -1
    # 180.degrees <=> (Math::PI).radians    # => 0
    # 90.degrees <=> (Math::PI / 4).radians # => 1
    # ```
    def <=>(other : Angle)
      self.value <=> {{@type.name(generic_args: false)}}.new(other).value
    end

    # Checks if the angle is zero.
    #
    # ```
    # 0.degrees.zero?  # => true
    # 90.degrees.zero? # => false
    # ```
    def zero?
      value.zero?
    end

    # Checks if the angle is close to zero.
    #
    # The value must be within *tolerance* of zero.
    #
    # ```
    # 0.degrees.near_zero?(1.degrees)  # => true
    # 1.degrees.near_zero?(1.degrees)  # => true
    # 30.degrees.near_zero?(1.degrees) # => false
    # ```
    def near_zero?(tolerance : self)
      value.abs <= tolerance.value
    end

    # Checks if the angle is close to zero.
    #
    # The value must be within *tolerance* of zero.
    #
    # ```
    # 0.radians.near_zero?(1.degrees)        # => true
    # 0.01.radians.near_zero?(1.degrees)     # => true
    # Math::PI.radians.near_zero?(1.degrees) # => false
    # ```
    def near_zero?(tolerance : Angle)
      value.abs <= {{@type.name(generic_args: false)}}.new(tolerance).value
    end

    # Checks if the angle is close to zero.
    #
    # The value must be within *tolerance* of zero.
    #
    # ```
    # 0.degrees.near_zero?(1)  # => true
    # 1.degrees.near_zero?(1)  # => true
    # 30.degrees.near_zero?(1) # => false
    # ```
    def near_zero?(tolerance : Number)
      value.abs <= tolerance
    end

    # Checks if the angle is positive.
    #
    # ```
    # 5.degrees.positive?  # => true
    # -5.degrees.positive? # => false
    # ```
    def positive?
      value.positive?
    end

    # Checks if the angle is negative.
    #
    # ```
    # -5.degrees.negative? # => true
    # 5.degrees.negative?  # => false
    # ```
    def negative?
      value.negative?
    end
  end
end
