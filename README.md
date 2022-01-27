Geode
=====

Mathematics library for Crystal supporting vectors, matrices, quaternions, and more.

Installation
------------

Add this to your application's `shard.yml`:

```yaml
dependencies:
  geode:
    gitlab: arctic-fox/geode
    version: ~> 0.1.0
```

Usage
-----

**TODO**

Development
-----------

This shard is still in active development.
New features are being added and existing functionality improved.

### Feature Progress

In no particular order, features that have been implemented and are planned.
Items not marked as completed may have partial implementations.

- [ ] Vectors
    - [X] Vector1
    - [X] Vector2
    - [X] Vector3
    - [X] Vector4
    - [X] Vector
    - [X] Common
    - [X] Operations
    - [X] Geometry
    - [X] Matrices
    - [X] Comparison
    - [ ] Unit optimizations
- [ ] Matrices
    - [X] Matrix1xN (1x1, 1x2, 1x3, 1x4)
    - [X] Matrix2xN (2x1, 2x2, 2x3, 2x4)
    - [X] Matrix3xN (3x1, 3x2, 3x3, 3x4)
    - [X] Matrix4xN (4x1, 4x2, 4x3, 4x4)
    - [X] Matrix
    - [X] Common
    - [X] Operations
    - [ ] Square
        - [X] Diagonal
        - [X] Trace
        - [ ] Determinant for generic matrices
        - [ ] Inverse
    - [X] Vectors
    - [X] Transforms
        - [X] 2D
        - [X] 3D
        - [ ] Projection
    - [X] Iterators
    - [X] Comparison
- [ ] Quaternions
- [ ] Polar
    - [ ] 2D
    - [ ] Spherical 3D
    - [ ] Cylindrical 3D
- [ ] Angles
    - [X] Radians
    - [X] Degrees
    - [X] Turns
    - [X] Gradians
    - [ ] Byte degrees
    - [X] Extensions & conversions
- [ ] Primitives
    - [ ] Shapes
    - [ ] Lines
    - [ ] Points
    - [ ] Planes
- [ ] Curves
    - [ ] Polynomial
    - [ ] Bézier
    - [ ] Splines
- [ ] Functions
    - [X] Lerp
    - [ ] Slerp
    - [ ] Edge
    - [X] Min/max
- [X] Extensions
    - [X] Angles
    - [X] Vector scalar
    - [X] Matrix scalar

Contributing
------------

1. Fork it (GitHub <https://github.com/icy-arctic-fox/geode/fork> or GitLab <https://gitlab.com/arctic-fox/geode/fork/new>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull/Merge Request

Please make sure to run `crystal tool format` before submitting.
The CI build checks for properly formatted code.
[Ameba](https://crystal-ameba.github.io/) is run to check for code style.

Documentation is automatically generated and published to GitLab pages.
It can be found here: https://arctic-fox.gitlab.io/geode

This project's home is (and primarily developed) on [GitLab](https://gitlab.com/arctic-fox/geode).
A mirror is maintained to [GitHub](https://github.com/icy-arctic-fox/geode).
Issues, pull requests (merge requests), and discussion are welcome on both.
Maintainers will ensure your contributions make it in.

### Testing

Tests must be written for any new functionality.

The `spec/` directory contains feature tests as well as unit tests.
These demonstrate small bits of functionality.
The feature tests are grouped into sub directories based on their type.
