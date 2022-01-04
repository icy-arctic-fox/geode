require "./angle"

module Geode
  # Unit type for an angle measured in gradians (gons).
  #
  # The *T* type parameter is the type used to store the angle's value.
  # It should be a numerical type, preferably `Float32` or `Float64`.
  struct Gradians(T) < Angle(T)
    # Creates an angle by converting an existing one to gradians.
    def self.new(angle : Angle) : self
      value = angle.to_gradians.value
      new(value)
    end

    # Amount of gradians to complete a full revolution (360 degrees).
    def self.full : self
      new(T.new(400))
    end

    # Amount of gradians to complete a half revolution (180 degrees).
    def self.half : self
      new(T.new(200))
    end

    # Amount of gradians to complete a third of a revolution (120 degrees).
    def self.third : self
      new(T.new(400 / 3))
    end

    # Amount of gradians to complete a quarter of a revolution (90 degrees).
    def self.quarter : self
      new(T.new(100))
    end

    # Converts this angle to radians.
    def to_radians : Radians
      Radians.new(value / 200 * Math::PI)
    end

    # Converts this angle to degrees.
    def to_degrees : Degrees
      Degrees.new(value / 10 * 9)
    end

    # Converts this angle to turns.
    def to_turns : Turns
      Turns.new(value / 400)
    end

    # Converts this angle to gradians.
    #
    # Simply returns self.
    def to_gradians : Gradians
      self
    end

    # Produces a string containing the angle.
    #
    # The string is formatted as:
    # ```text
    # # grad
    # ```
    def to_s(io : IO) : Nil
      io << value << " grad"
    end
  end
end
