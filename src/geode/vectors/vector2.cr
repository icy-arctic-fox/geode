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
    macro [](x, y)
      {{@type.name(generic_args: false)}}.new({{x}}, {{y}})
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
    # Converts to the specified *type* of `Angle`.
    # The angle will be between zero and one revolution.
    #
    # ```
    # Vector2[1, 1].angle(Degrees) # => 45.0°
    # ```
    def angle(type : Angle.class) : Angle
      signed_angle(type).normalize
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

    # Computes the rotation of the vector.
    #
    # Converts to the specified *type* of `Angle`.
    # The angle will be between ± half a revolution.
    #
    # ```
    # Vector2[1, 1].signed_angle(Degrees) # => 45°
    # Vector2[-1, -1].signed_angle(Turns) # => -0.375 turns
    # ```
    def signed_angle(type : Angle.class) : Angle
      radians = Radians.new(signed_angle)
      type.new(radians)
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

    # Computes the angle between this vector and another.
    #
    # Converts to the specified *type* of `Angle`.
    # The angle will be between ± half a revolution.
    #
    # The smallest angle between the vectors is calculated.
    #
    # Positive values indicate that the *other* vector can be reached by rotating this vector in a *positive* direction.
    # On a standard coordinate system, this means rotating counter-clockwise.
    # Negative values indicate the opposite - clockwise rotation.
    #
    # ```
    # Vector2[1, 1].signed_angle(Vector2[-1, 0], Degrees) # => 135°
    # Vector2[1, 1].signed_angle(Vector2[1, -1], Turns)   # => -0.25 turns
    # ```
    def signed_angle(other : CommonVector(U, 2), type : Angle.class) : Angle forall U
      radians = Radians.new(signed_angle(other))
      type.new(radians)
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
