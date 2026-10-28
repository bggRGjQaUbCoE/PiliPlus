# PiliPlus: development HEAD and pinned tag source policy

- **Local:** build from the present local source worktrees. The committed
  pubspec_overrides.yaml uses ../media-kit path dependencies. Do not reset
  or pull a user's working tree from the CI scripts.
- **Push on feature/dv:** one plan job resolves Goodwu-owned dependencies
  from their configured branches in dev-branches.json, once per run. The
  resulting SHA snapshot and effective native inputs are passed to both jobs.
  Android: recipe/mpv/FFmpeg = feature/dv; libplacebo =
  optimize/dovi-linear-decode. The third-party helper retains its pinned SHA.
- **Other platforms:** default upstream binary sources remain immutable.
  If a source profile is selected, Goodwu-owned source checkouts use their
  configured branch HEAD. Source mode for Darwin currently follows
  ci/source-native-packages, as that repo has no feature/dv branch.
- **Tag (v*):** uses the source SHA anchors in the tagged
  tool/native/inputs.lock.json. A missing media_kit.commit is a hard error,
  never resolved from a moving branch. The existing native anchors are not
  updated until integration and device regressions are accepted. After testing,
  copy the accepted SHA set into that lock, commit, then tag that commit.
- **Consistency:** a source manifest is carried into native and application
  jobs. pubspec_overrides.yaml binds all SDK packages to the checked-out
  media-kit SHA, regardless of the fallback refs in pubspec.yaml.
- **Evidence:** retain the source manifest, native receipt and application
  build-provenance.json. Compilation success does not assert DV/HDR device
  playback success.
