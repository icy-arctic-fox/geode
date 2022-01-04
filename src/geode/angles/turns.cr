require "./angle"

module Geode
  # Unit type for an angle measured in turns.
  #
  # The *T* type parameter is the type used to store the angle's value.
  # It should be a numerical type, preferably `Float32` or `Float64`.
  struct Turns(T) < Angle(T)
    # Creates an angle by converting an existing one to turns.
    def self.new(angle : Angle) : self
      value = angle.to_turns.value
      new(value)
    end

    # Amount of turns to complete a full revolution (360 degrees).
    def self.full : self
      new(T.new(1))
    end

    # Amount of turns to complete a half revolution (180 degrees).
    def self.half : self
      new(T.new(0.5))
    end

    # Amount of turns to complete a third of a revolution (120 degrees).
    def self.third : self
      new(T.new(1 / 3))
    end

    # Amount of turns to complete a quarter of a revolution (90 degrees).
    def self.quarter : self
      new(T.new(0.25))
    end

    # Converts this angle to radians.
    def to_radians : Radians
      Radians.new(value * Math::TAU)
    end

    # Converts this angle to degrees.
    def to_degrees : Degrees
      Degrees.new(value * 360)
    end

    # Converts this angle to gradians.
    def to_gradians : Gradians
      Gradians.new(value * 400)
    end

    # Converts this angle to turns.
    #
    # Simply returns self.
    def to_turns : Turns
      self
    end

    # Produces a string containing the angle.
    #
    # The string is formatted as:
    # ```text
    # # turn
    # ```
    def to_s(io : IO) : Nil
      io << value << " turn"
    end
  end
end
