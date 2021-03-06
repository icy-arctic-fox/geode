# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.1] - 2022-02-06
### Added
- Automatically cast values when type parameter doesn't match arguments.
- `new` method for square matrices that accepts a scalar to populate the diagonal.
- `ortho` and `perspective` projection methods for 4x4 matrices.
- Add x, y, z, and w component getters for generic vector type.
- Add cross-product for generic vector type.
- `look_at` methods for 4x4 matrices.

## [0.2.0] - 2022-02-04
### Added
- [`#inv`](https://arctic-fox.gitlab.io/geode/Number.html#inv-instance-method) extension method.
- Matrix inverse for matrices 1x1 to 3x3.
- 2D and 3D transforms for 2x2, 3x3, and 4x4 matrices.

### Changed
- Added some type restrictions to clarify in docs and change others to be more permissive (int to float).

### Removed
- Removed conflicting matrix `scale` method (replaced with transform).

## [0.1.0] - 2022-01-26
First version ready for public use.

[Unreleased]: https://gitlab.com/arctic-fox/geode/-/compare/v0.2.1...master
[0.2.1]: https://gitlab.com/arctic-fox/geode/-/compare/v0.2.0...v0.2.1
[0.2.0]: https://gitlab.com/arctic-fox/geode/-/compare/v0.1.0...v0.2.0
[0.1.0]: https://gitlab.com/arctic-fox/geode/-/releases/v0.1.0
