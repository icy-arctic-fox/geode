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

    # Returns true if the angle is greater than zero and less than a right-angle (quarter revolution).
    #
    # ```
    # 0.degrees.acute?  # => false
    # 45.degrees.acute? # => true
    # 90.degrees.acute? # => false
    # ```
    def acute?
      value > 0 && self < self.class.quarter
    end

    # Returns true if the angle is a right angle (quarter revolution).
    #
    # Multiples of quarter revolutions are not considered right angles.
    #
    # ```
    # 0.degrees.right?   # => false
    # 90.degrees.right?  # => true
    # 180.degrees.right? # => false
    # 270.degrees.right? # => false
    # ```
    def right?
      self == self.class.quarter
    end

    # Returns true if the angle is greater than a right angle and less than a straight angle.
    #
    # ```
    # 90.degrees.obtuse?  # => false
    # 135.degrees.obtuse? # => true
    # 180.degrees.obtuse? # => false
    # ```
    def obtuse?
      self > self.class.quarter && self < self.class.half
    end

    # Returns true if the angle is a straight angle (half revolution).
    #
    # Multiples of half revolutions are not considered straight angles.
    #
    # ```
    # 0.degrees.straight?   # => false
    # 180.degrees.straight? # => true
    # 360.degrees.straight? # => false
    # ```
    def straight?
      self == self.class.half
    end

    # Returns true if the angle is greater than a straight angle and less than a full angle.
    #
    # ```
    # 180.degrees.reflex? # => false
    # 270.degrees.reflex? # => true
    # 360.degrees.reflex? # => false
    # ```
    def reflex?
      self > self.class.half && self < self.class.full
    end

    # Returns true if the angle is a full angle (one revolution).
    #
    # Multiples of full revolutions are not considered full angles.
    #
    # ```
    # 0.degrees.full?   # => false
    # 360.degrees.full? # => true
    # 720.degrees.full? # => false
    # ```
    def full?
      self == self.class.full
    end

    # Returns true if the angle isn't a multiple of a right angle.
    #
    # ```
    # 45.degrees.oblique?  # => true
    # 90.degrees.oblique?  # => false
    # 180.degrees.oblique? # => false
    # 360.degrees.oblique? # => false
    # ```
    def oblique?
      !(self % self.class.quarter).zero?
    end
  end
end
