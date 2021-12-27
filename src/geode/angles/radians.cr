require "./angle"

module Geode
  # Unit type for an angle measured in radians.
  #
  # The *T* type parameter is the type used to store the angle's value.
  # It should be a numerical type, preferably `Float32` or `Float64`.
  struct Radians(T) < Angle(T)
    # Amount of radians to complete a full revolution (360 degrees).
    def self.full : self
      new(T.new(Math::TAU))
    end

    # Amount of radians to complete a half revolution (180 degrees).
    def self.half : self
      new(T.new(Math::PI))
    end

    # Amount of radians to complete a third of a revolution (120 degrees).
    def self.third : self
      new(T.new(Math::TAU / 3))
    end

    # Amount of radians to complete a quarter of a revolution (90 degrees).
    def self.quarter : self
      new(T.new(Math::PI / 2))
    end

    # Converts this value to radians.
    #
    # Simply returns self.
    def to_radians : Radians
      self
    end

    # Produces a string containing the angle.
    #
    # The string is formatted as:
    # ```text
    # # rad
    # ```
    def to_s(io : IO) : Nil
      io << value << " rad"
    end
  end
end
