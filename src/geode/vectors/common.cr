require "./comparison"
require "./operations"

module Geode
  # Common functionality across all vector types.
  #
  # This type primarily serves as a means to unify `VectorN(T)` and `Vector(T, N)` types.
  module CommonVector(T, N)
    include Indexable(T)
    include VectorComparison(N)
    include VectorOperations(N)

    # Returns the number of components in this vector.
    def size
      N
    end

    # Returns a new vector where components are mapped by the given block.
    #
    # ```
    # vector = Vector[1, 2, 3]
    # vector.map { |v| v * 2 } # => (2, 4, 6)
    # ```
    abstract def map(& : T -> U) : CommonVector forall U

    # Like `#map`, but the block gets the component and its index as arguments.
    #
    # Accepts an optional *offset* parameter, which to start the index at.
    #
    # ```
    # vector = Vector[1, 2, 3]
    # vector.map_with_index { |v, i| v * i }    # => (0, 2, 6)
    # vector.map_with_index(3) { |v, i| v + i } # => (4, 6, 8)
    # ```
    abstract def map_with_index(offset = 0, & : T, Int32 -> U) : CommonVector forall U

    # Produces a string representation of the vector.
    #
    # The format is: `(x, y, z)`
    # but with the corresponding number of components.
    def to_s(io : IO) : Nil
      io << '('
      join(io, ", ")
      io << ')'
    end

    # Produces a debugger-friendly string representation of the vector.
    def inspect(io : IO) : Nil
      io << self.class
      io << "#<"
      join(io, ", ")
      io << '>'
    end
  end
end
