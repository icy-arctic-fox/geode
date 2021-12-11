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

**TODO**

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
