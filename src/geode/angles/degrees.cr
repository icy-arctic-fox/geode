require "./angle"

module Geode
  # Unit type for an angle measured in degrees.
  #
  # The *T* type parameter is the type used to store the angle's value.
  # It should be a numerical type, preferably `Float32` or `Float64`.
  struct Degrees(T) < Angle(T)
    # Creates an angle by converting an existing one to degrees.
    def self.new(angle : Angle) : self
      value = angle.to_degrees.value
      new(value)
    end

    # Amount of degrees to complete a full revolution (360 degrees).
    def self.full : self
      new(T.new(360))
    end

    # Amount of degrees to complete a half revolution (180 degrees).
    def self.half : self
      new(T.new(180))
    end

    # Amount of degrees to complete a third of a revolution (120 degrees).
    def self.third : self
      new(T.new(120))
    end

    # Amount of degrees to complete a quarter of a revolution (90 degrees).
    def self.quarter : self
      new(T.new(90))
    end

    # Converts this angle to radians.
    def to_radians : Radians
      Radians.new(value / 180 * Math::PI)
    end

    # Converts this angle to degrees.
    #
    # Simply returns self.
    def to_degrees : Degrees
      self
    end

    # Converts this angle to turns.
    def to_turns : Turns
      Turns.new(value / 360)
    end

    # Converts this angle to gradians.
    def to_gradians : Gradians
      Gradians.new(value / 9 * 10)
    end

    # Produces a string containing the angle.
    #
    # The string is formatted as:
    # ```text
    # #°
    # ```
    def to_s(io : IO) : Nil
      io << value << '°'
    end
  end
end
