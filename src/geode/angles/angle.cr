module Geode
  # Base unit class for all rotation measurements.
  #
  # The *T* type parameter is the type used to store the angle's value.
  # It should be a numerical type, preferably `Float32` or `Float64`.
  abstract struct Angle(T)
    include Steppable

    # Underlying value.
    getter value : T

    # Creates an angle from the specified value.
    def initialize(@value : T)
    end

    # Creates an angle initialized at zero.
    def self.zero : self
      new(T.zero)
    end

    # Converts the angle to radians and returns it as a floating-point value.
    def to_f : Float
      to_radians.value.to_f
    end
  end
end

require "./comparison"
require "./operations"
