# Mathematics library supporting vectors, matrices, quaternions, and more.
module Geode
  # Current version of the Geode library.
  VERSION = {{ `shards version "#{__DIR__}"`.stringify.chomp }}
end
