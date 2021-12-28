require "../angles"

abstract struct Number
  # Returns a `Geode::Degrees` of `self` degrees.
  #
  # ```
  # 45.degrees # => 45°
  # ```
  #
  # See: `Geode::Degrees`
  def degrees
    Geode::Degrees.new(self)
  end

  # Returns a `Geode::Radians` of `self` radians.
  #
  # ```
  # Math::PI.radians # => 3.14 rad
  # ```
  #
  # See: `Geode::Radians`
  def radians
    Geode::Radians.new(self)
  end

  # Returns a `Geode::Turns` of `self` turns.
  #
  # ```
  # 0.25.turns # => 0.25 turns
  # ```
  #
  # See: `Geode::Turns`
  def turns
    Geode::Turns.new(self)
  end
end
