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

  # Returns a `Geode::Degrees` of `self` radians.
  #
  # ```
  # (Math::PI / 4).to_degrees # => 45°
  # ```
  #
  # See: `Geode::Degrees`
  def to_degrees
    radians.to_degrees
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

  # Returns a `Geode::Radians` of `self` radians.
  #
  # ```
  # Math::PI.to_radians # => 3.14 rad
  # ```
  #
  # See: `Geode::Radians`
  def to_radians
    radians
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

  # Returns a `Geode::Turns` of `self` radians.
  #
  # ```
  # (Math::PI / 4).to_turns # => 0.25 turns
  # ```
  #
  # See: `Geode::Turns`
  def to_turns
    radians.to_turns
  end

  # Returns a `Geode::Gradians` of `self` gradians.
  #
  # ```
  # 100.gradians # => 100 grad
  # ```
  #
  # See: `Geode::Gradians`
  def gradians
    Geode::Gradians.new(self)
  end

  # Returns a `Geode::Gradians` of `self` radians.
  #
  # ```
  # (Math::PI / 4).to_turns # => 100.0 grad
  # ```
  #
  # See: `Geode::Gradians`
  def to_gradians
    radians.to_gradians
  end
end
