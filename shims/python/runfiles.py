# Shim: docs-as-code imports `from python.runfiles import Runfiles` which is
# the @rules_python Bazel layout. Outside Bazel we use the PyPI package
# `bazel-runfiles`, which ships the same API under the top-level `runfiles`
# module. Re-export it under the dotted name so non-Bazel builds work.
from runfiles import *  # noqa: F401,F403
from runfiles import Runfiles  # noqa: F401  (explicit re-export)
