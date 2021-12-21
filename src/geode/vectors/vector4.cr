require "./base"

module Geode
  # Vector containing four components.
  # Provides a collection of scalars of the same type.
  #
  # *T* is the scalar type.
  struct Vector4(T) < VectorBase(T, 4)
    # Constructs a vector with existing components.
    #
    # The type of the components is derived from the type of each argument.
    #
    # ```
    # Vector4[1, 2, 3, 4] # => (1, 2, 3, 4)
    # ```
    macro [](x, y, z, w)
      {{@type.name(generic_args: false)}}.new({{x}}, {{y}}, {{z}}, {{w}})
    end

    # Creates a vector from its components.
    def initialize(x : T, y : T, z : T, w : T)
      array = uninitialized T[4]
      array[0] = x
      array[1] = y
      array[2] = z
      array[3] = w
      initialize(array)
    end

    # Creates a vector from its components.
    def initialize(components : Tuple(T, T, T, T))
      initialize(*components)
    end

    # Constructs the vector with pre-existing values.
    def initialize(array : StaticArray(T, 4))
      super
    end

    # Copies the contents of another vector.
    def initialize(other : CommonVector(T, 4))
      super
    end

    # Constructs the vector by yielding for each component.
    #
    # The value of each component should be returned from the block.
    # The block will be given the index of each component as an argument.
    #
    # ```
    # Vector4(Int32).new { |i| i * 5 } # => (0, 5, 10, 15)
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

    # Retrieves the w component.
    def w : T
      unsafe_fetch(3)
    end

    # Retrieves the components as a tuple.
    def tuple : Tuple(T, T, T, T)
      {x, y, z, w}
    end
  end

  alias Vector4I = Vector4(Int32)
  alias Vector4L = Vector4(Int64)
  alias Vector4F = Vector4(Float32)
  alias Vector4D = Vector4(Float64)
end
