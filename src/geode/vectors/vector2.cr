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
