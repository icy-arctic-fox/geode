require "./base"

module Geode
  # Vector containing three components.
  # Provides a collection of scalars of the same type.
  #
  # *T* is the scalar type.
  struct Vector3(T) < VectorBase(T, 3)
    # Constructs a vector with existing components.
    #
    # The type of the components is derived from the type of each argument.
    #
    # ```
    # Vector3[1, 2, 3] # => (1, 2, 3)
    # ```
    macro [](x, y, z)
      {{@type.name(generic_args: false)}}.new({{x}}, {{y}}, {{z}})
    end

    # Creates a vector from its components.
    def initialize(x : T, y : T, z : T)
      array = uninitialized T[3]
      array[0] = x
      array[1] = y
      array[2] = z
      initialize(array)
    end

    # Creates a vector from its components.
    def initialize(components : Tuple(T, T, T))
      initialize(*components)
    end

    # Constructs the vector with pre-existing values.
    def initialize(array : StaticArray(T, N))
      super
    end

    # Copies the contents of another vector.
    def initialize(other : CommonVector(T, N))
      super
    end

    # Constructs the vector by yielding for each component.
    #
    # The value of each component should be returned from the block.
    # The block will be given the index of each component as an argument.
    #
    # ```
    # Vector3(Int32).new { |i| i * 5 } # => (0, 5, 10)
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

    # Retrieves the z component.
    def z : T
      unsafe_fetch(2)
    end

    # Retrieves the components as a tuple.
    def tuple : Tuple(T, T, T)
      {x, y, z}
    end
  end

  alias Vector3I = Vector3(Int32)
  alias Vector3L = Vector3(Int64)
  alias Vector3F = Vector3(Float32)
  alias Vector3D = Vector3(Float64)
end
