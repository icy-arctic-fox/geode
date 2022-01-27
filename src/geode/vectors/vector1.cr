require "./base"

module Geode
  # Vector containing one component.
  #
  # Using this type generally doesn't make sense,
  # but it is included to complete some rules and combinations.
  #
  # *T* is the scalar type.
  struct Vector1(T) < VectorBase(T, 1)
    # Constructs a vector with existing components.
    #
    # The type of the components is derived from the type of each argument.
    #
    # ```
    # Vector1[1] # => (1)
    # ```
    def self.[](x : T)
      Vector1.new(x)
    end

    # Ensures that another vector and this one have the same size at compile-time.
    #
    # The *size* argument should be the type argument from the other vector type.
    #
    # ```
    # def something(other : CommonVector(T, N))
    #   same_size!(N)
    #   # ...
    # end
    # ```
    private macro same_size!(size)
      \{% raise "Vectors must be the same size for this operation (#{{{size}}} != 1)" if {{size}} != 1 %}
    end

    # Creates a vector from its components.
    def initialize(x : T)
      array = uninitialized T[1]
      array[0] = x
      initialize(array)
    end

    # Creates a vector from its components.
    def initialize(components : Tuple(T))
      initialize(*components)
    end

    # Constructs the vector with pre-existing values.
    def initialize(array : StaticArray(T, 1))
      super
    end

    # Copies the contents of another vector.
    def initialize(other : CommonVector(T, 1))
      super
    end

    # Constructs the vector by yielding for each component.
    #
    # The value of each component should be returned from the block.
    # The block will be given the index of each component as an argument.
    #
    # ```
    # Vector1(Int32).new { |i| i + 5 } # => (5)
    # ```
    def initialize(& : Int32 -> T)
      super { |i| yield i }
    end

    # Retrieves the x component.
    def x : T
      unsafe_fetch(0)
    end

    # Retrieves the components as a tuple.
    def tuple : Tuple(T)
      {x}
    end

    # Converts this vector to a row vector,
    # in other words a matrix with one row.
    #
    # ```
    # vector = Vector1[5]
    # vector.to_row # => [[5]]
    # ```
    def to_row : Matrix1x1(T)
      Matrix1x1.new(@array)
    end

    # Converts this vector to a column vector,
    # in other words a matrix with one column.
    #
    # ```
    # vector = Vector1[5]
    # vector.to_column # => [[5]]
    # ```
    def to_column : Matrix1x1(T)
      Matrix1x1.new(@array)
    end
  end

  # A one-dimensional vector.
  # Contains an x component.
  # The component is a 32-bit integer.
  alias Vector1I = Vector1(Int32)

  # A one-dimensional vector.
  # Contains an x component.
  # The component is a 64-bit integer.
  alias Vector1L = Vector1(Int64)

  # A one-dimensional vector.
  # Contains an x component.
  # The component is a 32-bit floating-point number.
  alias Vector1F = Vector1(Float32)

  # A one-dimensional vector.
  # Contains an x component.
  # The component is a 64-bit floating-point number.
  alias Vector1D = Vector1(Float64)
end
