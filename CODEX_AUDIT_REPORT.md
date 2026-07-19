# PiliPlus Audit Report

## Baseline

- Commit: `c1aeaca09e24f67e75685c7744fd1aa0a94b439a`
- Starting branch: `main`
- Audit branch: `codex/full-audit-fixes`
- Worktree before audit: clean
- Host: macOS 15.7.8 arm64
- Flutter: 3.44.6 (`ee80f08bbf`)
- Dart: 3.12.2
- Dependency resolution: `flutter pub get` passed; lockfile unchanged
- Format check: `dart format --output=none --set-exit-if-changed .` passed, 1280 files checked, 0 changed
- Analyze: nonzero with 37 info-level findings; no warnings or errors. Findings are primarily deprecations/cascade lints in vendored `lib/common/widgets/flutter/**`, plus one generated binding lint, one image API deprecation, and the existing package-name lint.
- Tests: unavailable at baseline; repository has no `test/` directory and `flutter test` exits with `Test directory "test" not found.`
- `git diff --check`: passed
- Android debug build: passed (`build/app/outputs/flutter-apk/app-debug.apk`, Gradle 562.6s on first run)
- iOS/macOS builds: blocked by incomplete Xcode installation and missing CocoaPods
- Windows/Linux builds: unsupported on the macOS host
- GitHub: issues are disabled; no open PRs and no Actions runs were returned for the repository

## Confirmed Bugs

| ID | Severity | Module | Evidence | Status | Commit |
|---|---|---|---|---|---|
| BUG-001 | P0 | HTTP/TLS | Proxy configuration installed accept-all certificate callbacks for HTTP/1.1 and HTTP/2; debug mode also bypassed the explicit warning/opt-in globally. Two proxy tests failed before the fix. | Fixed; 3 regression tests pass; analyzer unchanged from baseline | `964851a9f` |
| BUG-002 | P0 | HTTP/privacy | Network-error diagnostics serialized authenticated request URIs, exposing access keys and other credentials in debug logs and user-visible toasts. A sentinel regression test failed with every secret visible. | Fixed; diagnostic URLs retain only scheme/host/port/path; full suite passes | `af5523a62` |
| BUG-003 | P1 | Accounts/cookies | The request-selected account was not pinned into `RequestOptions`; response cookie persistence could re-resolve a newly active account after an in-flight switch. | Fixed; delayed-adapter regression test passes; integration-wide validation pending parallel cycles | `0a9ddb10f` |
| BUG-004 | P1 | HTTP retries | Global transport retry replayed non-idempotent writes up to two times and attempted to reuse finalized multipart bodies after ambiguous failures. | Fixed; only bodyless GET/HEAD retry automatically; 5 focused tests pass | `aa2a033c6` |
| BUG-005 | P1 | Settings restore | Import cleared both Hive settings boxes before validating the backup and could leave them empty/partially replaced after a write failure. | Fixed; sections validated before mutation and both boxes roll back together; 3 tests pass | `acc92464c` |
| BUG-006 | P1 | Download resume | Existing partial files were opened append-only before response validation; Range-ignored 200 and arbitrary 2xx/416 bodies could be appended and reported complete. | Fixed; response status/range validated before choosing truncate/append; 6 loopback tests pass | `af604131c` |
| BUG-007 | P1 | WebDAV backup | Backup deleted the existing valid remote file before writing its replacement, so an interrupted or failed upload could leave no usable backup. | Fixed; upload now completes at a unique temporary path before overwrite-MOVE; 2 regression tests pass | `7825224ac` |
| BUG-008 | P1 | Download cancellation | Pausing while danmaku or play-URL preflight was awaiting had no active transfer token to cancel; the stale operation continued into media resolution/manager creation and overwrote the paused state. | Fixed; operation generation invalidates stale preflight work; 2 deterministic race tests and all 8 download tests pass | `d0434bc90` |
| BUG-009 | P2 | Search suggestions | Debouncing request starts did not order their completions; an older response could replace suggestions for the current text, and a pending debounced request could repopulate suggestions after clear. | Fixed; query identity/generation gates request start and response application; 3 deterministic tests pass | `fb5250476` |
| BUG-010 | P2 | Image downloads | Dismissing a batch-image download only toggled an unused token; cached fetches continued and gallery/file-save side effects ran before cancellation was checked. | Fixed; pre/mid-fetch cancellation now prevents the save phase and desktop batches stop between files; 3 regression tests pass | `edca471a9` |
| BUG-011 | P2 | Article parsing | `ArticleViewData` retained a `title` field, but a model-cleanup change removed both its constructor parameter and JSON assignment; the reader therefore lost titles when its optional fallback metadata request was disabled. | Fixed; title construction/parsing restored; live response and focused regression test verified | `31ad9c612` |
| BUG-012 | P2 | All-search parsing | The all-search parser duplicated the `media_bangumi` switch label, never recognized `media_ft`, and flattened PGC items even though the view only renders typed PGC groups; bangumi and film cards were invisible. | Fixed; both response types are retained as renderable typed groups; live sample and regression test verified | `3c31e52a2` |
| BUG-013 | P1 | WebView authentication | Every WebView creation requested a cache clear; the pinned iOS/macOS implementation removes all default `WKWebsiteDataStore` data, including the Bilibili cookies deliberately seeded for authenticated pages. Geetest repeated the global clear despite incognito isolation. | Fixed; both settings preserve the shared store while explicit user-triggered cache clearing remains; 2 policy tests pass | `8a4f286ce` |
| BUG-014 | P1 | Video switching | While one URL lookup was running, a new episode request was dropped; the old response then read mutable current IDs and could initialize/autoplay the wrong source. Invalidation during player setup also allowed stale post-init work. | Fixed; requests snapshot identity, latest pending work wins, and player setup is generation/ownership guarded; 6 focused tests pass | `d77a9c2b3` |
| BUG-015 | P1 | SponsorBlock | Episode A's unawaited SponsorBlock response could arrive after episode B and repopulate A's skip segments, causing incorrect seeks in B. | Fixed; response application is guarded by the originating video generation and controller liveness | `d77a9c2b3` |
| BUG-016 | P2 | Deep links | Official-host checks used substring matching, so domains such as `evilbilibili.com` and `bilibili.com.evil.test` were treated as Bilibili/b23 hosts and could be routed as trusted in-app links. | Fixed; trust requires the exact registrable domain or a dot-delimited subdomain; focused boundary test passes | `6de0a5528` |
| BUG-017 | P0 | HTTP/privacy | The repository's debug `LogInterceptor` disabled headers but retained Dio's default request/response URL and error logging, exposing injected access keys, CSRF values, and authorization codes on both success and failure. | Fixed; all URL/body/header/error output is explicitly disabled; 2 fake-adapter sentinel tests pass | `cff674b3c` |
| BUG-018 | P1 | Multi-account logout | The server-confirmed logout action always targeted `Accounts.main`, even when the user selected another or several accounts, then deleted the selected accounts locally. This could invalidate the wrong session while leaving selected sessions active remotely. | Fixed; every selected account is remotely targeted and only successful accounts are deleted locally; 3 partial-failure tests pass | `b638d183a` |
| BUG-019 | P1 | WebView cookies | Cookie synchronization constructed origins with a literal space and omitted the scheme off Windows (`" .bilibili.com"`), while Windows produced `"https:// .bilibili.com"`; platform cookie managers reject these invalid origins. | Fixed; leading-dot domains normalize to absolute HTTPS origins; 3 focused tests pass | `b638d183a` |
| BUG-020 | P2 | Manual cookie login | The post-validation persistence parser did not trim cookie names and rejoined value fragments without `=`, so ordinary spaced headers failed local account construction and padded cookie values were corrupted. | Fixed; request and persistence share one validated parser that preserves names/values consistently; 3 focused tests pass | `8551feb6d` |
| BUG-021 | P1 | Audio switching | Concurrent selections read mutable IDs after awaiting URL/player setup, so an older response could open or commit the wrong track; overlapping native opens and player creation were not ordered or safely discarded. | Fixed; immutable latest-wins requests, serialized paused opens, shared initialization, and stale cleanup are covered by 9 deterministic tests | `111fbb347` |
| BUG-022 | P1 | Audio focus/session | Dedicated audio bypassed interruption/noisy events and multiple players could acquire/release a shared session out of order; denied focus and delayed duck writes could leave incorrect playback/volume state. | Fixed; exact active-client ownership, serialized session events, corrective duck restore, and failure cleanup are covered by 9 tests | `111fbb347` |
| BUG-023 | P1 | Background media ownership | Direct audio notifications depended on a video-controller singleton and global callbacks; nested audio/video pages could control or overwrite a newer owner's media state, while disabled background playback skipped cleanup. | Fixed; exact media-owner tags/callbacks gate control, status, position, and disposal in both directions; 6 tests pass | `111fbb347` |
| BUG-024 | P1 | Shared list/data controllers | A mandatory reload arriving during load-more was dropped by `isLoading`; `onReload` had already replaced state with `Loading`, so the stale response could not append and the page remained loading forever. Identity changes could likewise accept stale account/keyword results. | Fixed; active requests are generation-gated and one latest mandatory refresh is drained before the returned future completes; 7 deterministic controller tests pass | `4a9733d2a` |
| BUG-025 | P1 | Async UI actions | Reply reactions passed a processing flag by value, allowing duplicate writes/count deltas; other shared action/send gates were not released on early returns or exceptions. | Fixed; state-owned `try/finally` operation guards serialize reactions, private messages, and intro actions while snapshotting mutation targets; 2 focused guard tests pass | `371b85f70` |
| BUG-026 | P1 | Private messages | Ctrl+Enter on the multiline private-message editor follows the framework submit path into `onCustomPublish`, whose override unconditionally threw `UnimplementedError`; delayed sends could also update a disposed controller. | Fixed; shortcut and button share the normal send path and post-await work checks controller liveness; widget shortcut regression passes | `371b85f70` |
| BUG-027 | P1 | Rich-text publishing | Upload failures are returned as `LoadingState.Error`, whose `.data` getter throws that object; the page caught only `HttpException`, leaving sibling uploads and a blocking loading dialog active. | Fixed; an upload coordinator cancels siblings, dismisses in `finally`, reports every failure type, and prevents publish; 2 tests pass | `f884d52d0` |
| BUG-028 | P1 | Favorite editor lifecycle | Folder metadata completion unconditionally wrote disposed text controllers and called `setState` after the edit page was popped. | Fixed; completion checks `mounted` before every state/controller mutation; widget regression passes | `11708a933` |
| BUG-029 | P2 | Reply lifecycle | `VideoReplyReplyController.onClose` called `super.dispose()` instead of `super.onClose()`, skipping inherited `CommonController` cleanup and leaking its scroll controller. | Fixed; the GetX close chain is restored and a lifecycle regression verifies inherited disposal | `11708a933` |
| BUG-030 | P1 | Account switching | Overlapping main/history account transitions could apply older validation, cache, service-notification, and cookie work after a newer selection. | Fixed; transition generations and identity checks make the newest account authoritative; focused account/service tests pass | `e56de3cff` |
| BUG-031 | P1 | Resource mutations | Several follow/favorite/delete/like writes used mutable controller state or a single global busy flag, so duplicate submissions and late results could affect a replacement resource. | Fixed; mutations capture stable resource keys and use keyed guards; focused mutation tests pass | `9cbb16626` |
| BUG-032 | P1 | Async list items | Post-await callbacks retained list indices or stale objects; a refresh/reorder could make delete/pin/reaction results mutate the wrong current row. | Fixed; callbacks resolve current items by stable identity and safely no-op when absent; reconciliation tests pass | `76e9541eb` |
| BUG-033 | P1 | Settings import | Transactional restore still accepted arbitrary Hive-serializable types and invalid enum/list indices; a valid-looking backup such as `uiScale: "bad"` or malformed boot preferences persisted and crashed every subsequent launch before `runApp`. | Fixed; startup-critical types, numeric normalization, enum ranges, and structured lists are validated before either box changes; 7 storage tests pass | `d50030954` |
| BUG-034 | P2 | macOS DLNA | The sandboxed Release entitlement allowed outbound networking but omitted `network.server`, although DLNA binds UDP/1900 and a receive socket; DebugProfile had the required capability. | Fixed; signed Release policy now enables client and server networking; entitlement policy test and `plutil` pass | `86094e5ba` |
| BUG-035 | P2 | DLNA lifecycle | A discovery bind failure permanently left the page busy, and disposal while `start()` awaited could occur before sockets/timers existed; the late completion then returned without stopping newly created resources. | Fixed; failure/unmounted/final cleanup is idempotent and retryable; 2 delayed-start tests pass | `f43ae0cd7` |
| BUG-036 | P2 | Live Photo/temp files | Downloaded Live Photo videos were deleted only around the iOS maker call; Android success and pre-save failures retained full temporary video files indefinitely. | Fixed; shared `finally` cleanup covers all platforms and outcomes; 3 temp-file regressions pass | `b0c9a1160` |
| BUG-037 | P2 | Home tabs | Settings allowed all Home tabs to be unchecked and stored `[]`; Home treated only null as default, constructed a zero-length tab set, and indexed it on refresh. | Fixed; null/empty/malformed/all-invalid configurations resolve to defaults while valid order is preserved; 3 tests pass | `ff6df05c4` |
| BUG-038 | P2 | WebP export | Immediate cancellation could call `dispose()` before the awaited native MPV handle initialized, throwing `LateInitializationError`; completed/cancelled/failed `.webp` outputs were also never removed from temp storage. | Fixed; late handles are disposed exactly once after cancellation and every export path uses final temp cleanup; 4 tests pass | `4cc38e9b5`, `b0c9a1160` |
| BUG-039 | P1 | Settings import | Remaining persisted enum and typed-list values (`cacheVideoFit`, danmaku block types, and color blocks) were not semantically validated and could crash consumers after import. | Fixed; enum bounds and typed list lengths/elements are validated before storage mutation; all storage tests pass | `caa8eb2d7` |
| BUG-040 | P1 | WebView cookies | Explicit account replacement deleted only one exact cookie domain/path, leaving host-only, subdomain, and non-root Bilibili credentials from the prior account. | Fixed inside the replacement operation: Apple platforms enumerate/delete all label-bound Bilibili cookies; Android/Windows use the only complete-clear API. A separate transition-timing gap remains OPEN-001. | `cdcbecb66` |
| BUG-041 | P1 | History privacy | Cached history-pause state was not account-bound and could fail open after an account switch or malformed cache, allowing history reporting under the wrong privacy preference. | Fixed; cache is account-keyed and defaults to paused on mismatch/malformed data; 2 focused tests pass | `cdcbecb66` |
| BUG-042 | P1 | Account import/reset | Imports could preserve conflicting mode ownership, same-MID replacement objects remained live, and reset could clear storage without tombstoning every active/stored account, allowing late responses to repopulate credentials. | Fixed; modes are rebuilt deterministically, replacements/reset tombstone live objects, and late persistence is rejected; account tests pass | `cdcbecb66` |
| BUG-043 | P2 | Account UI state | Reset/delete paths could leave Mine anonymity and account-service identity state inconsistent even though the active account had changed. | Fixed; anonymity and service notifications are recomputed from current identity; account/service tests pass | `cdcbecb66` |
| BUG-044 | P1 | Dynamic likes | Dynamic-like deduplication and post-await reconciliation used MID equality/global account state, so same-MID replacement accounts could share a guard or receive stale UI updates. | Fixed; requests capture the exact account object and identity-keyed guards isolate replacements; regression tests cover different and same-MID accounts | `cdcbecb66`, `4d73b9bd1` |
| BUG-045 | P0 | Media diagnostics/privacy | Signed media resolver URLs and exception text could expose access tokens/signatures in diagnostics. | Fixed; diagnostics retain only non-secret URL components and resolver failures log only exception type; sentinel test passes | `06626611f`, `6ffd6ac57` |
| BUG-046 | P1 | Async submissions/routes | Vote, reserve, block, review, and favorite submissions could be sent twice; delayed success used global `Get.back()` and could pop a newer route. | Fixed; state-owned submission gates and exact initiating-route completion prevent duplicates and stale navigation; focused tests pass | `45dbcfa5c`, `4d73b9bd1` |
| BUG-047 | P2 | Music wish state | Concurrent/stale wish mutations could drift counts, underflow, or update a replacement account/resource. | Fixed; mutations are keyed by exact account/resource identity and reconcile counts only when status changes; 3 state tests pass | `45dbcfa5c`, `4d73b9bd1` |
| BUG-048 | P1 | Video side requests | Play metadata, subtitles, danmaku trends, viewpoints, and Stein-edge responses could arrive after a media switch and populate the new video with old auxiliary state. | Fixed; every side response is bound to immutable media identity plus generation; focused media-guard tests pass | `f24eb987f` |
| BUG-049 | P1 | List mutation reconciliation | A read started before a successful write could complete afterward and restore deleted/unpinned state; member dynamics also reconciled against stale object references. | Fixed; writes invalidate older reads and queue a fresh reconciliation; stable-ID tests pass | `f24eb987f` |
| BUG-050 | P1 | Imported layout ratios | `dynamicDetailRatio` accepted zero/negative values; landscape music layout used them as `Expanded.flex` values and divided by their sum, producing invalid layout/NaN. | Fixed; both entries must be positive; the regression failed before the fix and all 7 storage tests pass | `9eae55089` |
| BUG-051 | P1 | Media actions/account identity | Like/triple/coin/favorite operations used MID equality and mutable account/resource state; a same-MID account replacement or media switch could target stale credentials, drop a distinct action, or mutate the new UI. | Fixed; exact identity keys, account-pinned HTTP/gRPC requests, and per-resource FIFO action coordination reject stale completions while deduplicating only the same action kind | `4d73b9bd1` |
| BUG-052 | P1 | Download completion ownership | Late transfer callbacks could complete a paused/replaced entry; cancellation during completion metadata persistence could lose, and deleting A while starting B could resurrect A in the completed list after its directory was removed. | Fixed; callbacks capture entry/operation ownership, metadata writes are serialized, and per-entry deletion tombstones win all interleavings; 4 deterministic race regressions pass | `6ffd6ac57` |
| BUG-053 | P2 | WebP export UX | Opening the WebP range dialog paused playback, but cancelling the dialog returned without restoring playback. | Fixed; cancellation resumes only when playback had previously been active; 2 regressions cover cancel and confirm | `d6f2ed775` |

## Confirmed but Deferred

The user requested that further fixes stop on 2026-07-18. These are confirmed current-code defects, not guesses; no production changes were made for them.

| ID | Severity | Module | Evidence | Recommended fix/test |
|---|---|---|---|---|
| OPEN-001 | P1 | WebView account transition | Startup uses additive `LoginUtils.setWebCookie()`, and `onLoginMain()` does not replace the shared cookie store until after remote user-info validation. Old host/subdomain/path credentials can therefore remain active under the newly selected main account, indefinitely when validation throws. | Replace the shared store before validation and make startup reset authoritative; add an injected cookie-manager ordering/failure regression. |
| OPEN-002 | P2 | Video media-list pagination | The last-item builder can call `getMediaList()` repeatedly while a request is in flight. Concurrent calls snapshot the same boundary and each `addAll` the identical page; reverse/previous requests can also mix completion order. | Add a distinct-request latest/serial coordinator and completer-backed pagination tests for duplicate, reverse, and previous-page interleavings. |
| OPEN-003 | P1 | Article actions/account identity | `ArticleController` keys actions only by article identifiers and its favorite/like writes use global-account HTTP defaults. A response from account A after switching to B still passes the resource check and mutates B-visible stats/toasts. | Include exact account identity in the action key, pin the account into article/community requests, and test a same-MID replacement. |
| OPEN-004 | P2 | Reserve editor snapshot | `CreateReserveController.onCreate()` sends the pre-await title but builds the returned `ReserveInfoData` from the still-editable post-await `title.value`; the local card can disagree with the server. | Snapshot title/subtype/time once and use that snapshot for request and result; add a completer-backed controller test. |

## Suspected Issues

| ID | Confidence | Module | Reason | Required Verification |
|---|---|---|---|---|
| CAND-008 | Medium | Live WebSocket parsing | `PackageHeaderRes` accepts 10–15 byte inputs but reads a 16-byte header, causing `RangeError`; WebSocket framing provides no evidence the live server emits truncated protocol records. | Capture a real truncated frame or harden opportunistically with a parser-contract test. |
| CAND-009 | Low | Reply translation | A build-local translation gate can be recreated across rebuilds and may not release on exceptional completion. | Reproduce duplicate translation requests through a rebuild/throwing requester before adding persistent state. |
| CAND-010 | Low | iOS deep links | Nested URL-type metadata and absent associated-domain configuration look inconsistent, but a universal-link fix depends on an externally hosted AASA file and product intent. | Validate the signed app with the production AASA/domain owner on an iOS device. |

## Environment Blockers

- Flutter/Dart were not on `PATH`; the exact official Flutter 3.44.6 macOS ARM64 SDK was installed in a dedicated cache outside the repository.
- Android SDK existed but was not configured for the new Flutter SDK; it was configured explicitly. The first build installed required NDK 28.2.13676358, Build Tools 36, and CMake 3.22.1.
- Full Xcode and CocoaPods are unavailable, so iOS/macOS builds cannot be performed.
- Windows and Linux builds require their respective hosts.
- There are no baseline automated tests.

## Completed Audit Areas

- Repository rules, README, analyzer configuration, CI workflows, pubspec, toolchain, branch, SHA, and worktree inventory
- Initial dependency/format/analyzer/test/diff/build baseline
- Multiple independent passes over network/TLS/retry/logging, accounts/cookies/WebView, API write operations, and account-switch isolation
- Multiple independent passes over video/audio/player/background ownership, GetX/Flutter lifecycle, route completion, lists/pagination, and async response ordering
- Multiple independent passes over downloads/resume/cancellation, cache/temp files, image export, WebDAV, settings import, JSON/model parsing, links, DLNA, and cross-platform policy
- Repository-wide risk-pattern searches for stale async writes, mutable post-await targets, duplicate submissions, disposal, unsafe imports, credential-bearing diagnostics, and platform divergence
- Final integration gate after 41 local commits: 1341 Dart files formatted with 0 changes; 139/139 tests passed; analyzer remained exactly at the 37 baseline info findings with no warnings/errors; `git diff --check` passed; Android debug APK built successfully (Gradle 30.1s)

## Areas Remaining

- Implement and regress OPEN-001 through OPEN-004; they were deliberately deferred at the user's request.
- Verify CAND-008 through CAND-010 with real protocol/device/product evidence before changing production code.
- Run iOS and macOS builds/runtime checks on a host with full Xcode and CocoaPods; run Windows/Linux builds and native smoke tests on those hosts.
- Exercise authenticated account/WebView/media paths on test accounts/devices; this audit intentionally avoided destructive live-service writes.
- The original convergence criterion of three consecutive complete cycles without a new high-confidence P0/P1/P2 finding was **not reached**. Cycle 17's closure review found OPEN-001 through OPEN-004, and the user then requested an audit stop before Cycles 18–20.

## Cycle History

### Baseline — 2026-07-18

- Recorded clean starting state at `c1aeaca09`.
- Created `codex/full-audit-fixes` from `main`.
- Installed and verified the exact pinned Flutter/Dart toolchain outside the repository.
- Ran dependency, format, analyzer, test, diff, doctor, GitHub, and Android build checks.
- No product code changed. Nine high-confidence candidates from read-only audit await reproduction and main-agent confirmation.

### Cycle 1 — HTTP/TLS security

- Confirmed BUG-001 with two failing regression tests: both proxy adapters accepted invalid certificates while the explicit preference was false.
- Separated proxy routing from certificate policy for HTTP/1.1 and HTTP/2.
- Removed the implicit debug-build certificate bypass; the existing separately confirmed preference remains supported.
- Added `test/http/http_pool_config_test.dart` with three adapter-policy tests.
- Relevant test passed repeatedly; full test suite passed (3 tests).
- Analyzer returned only the same 37 baseline info findings; no new warning/error.
- `git diff --check` passed and repository-wide callback search found no other proxy-coupled TLS bypass.
- Local commit: `964851a9f fix(http): preserve TLS validation when proxying`.

### Cycle 2 — HTTP credential redaction

- Confirmed BUG-002 with a failing sentinel test containing URL user-info, access key, CSRF value, auth code, and fragment token.
- Reconstructed diagnostic URLs from only scheme, host, explicit port, and path before both debug printing and toast display.
- Added `test/utils/accounts/account_manager/account_mgr_test.dart`.
- Relevant and full test suites passed (4 tests total).
- Analyzer returned only the same 37 baseline info findings; `git diff --check` passed.
- Searched all remaining `requestOptions.uri`/URI-string diagnostics; the only remaining use is cookie persistence, not output.
- Local commit: `af5523a62 fix(http): redact credentials from error URLs`.

### Cycle 3 — Account-switch cookie isolation

- Confirmed BUG-003 with a failing delayed-adapter test: account A was resolved before the request, but `RequestOptions.extra['account']` remained null and response handling could resolve account B.
- Pinned the resolved account into the request synchronously before cookie loading or network I/O.
- Added an injected resolver only for deterministic interceptor testing; normal account-selection behavior is unchanged.
- Relevant test passed (2 account-manager tests); focused analyzer reported no issues; format and diff checks passed.
- Full-suite/analyzer integration validation is deferred until the concurrently running download/video/retry cycles finish writing their tests.
- Local commit: `0a9ddb10f fix(accounts): pin request account for cookie persistence`.

### Cycle 4 — Safe transport retry policy

- Confirmed BUG-004: before the fix, a simulated POST was attempted three times and multipart retry failed after re-finalizing the same body.
- Restricted automatic ambiguous-transport retries to bodyless GET/HEAD requests. No write opt-in was added because the repository has no idempotency/replayability contract.
- Added `test/http/retry_interceptor_test.dart` with five fake-adapter cases for GET/HEAD retry count, POST single-attempt behavior, and body/multipart protection.
- Focused tests passed; focused analyzer reported no issues; format and diff checks passed.
- Full integration validation remains queued behind the concurrent download/video test work.
- Local commit: `aa2a033c6 fix(http): avoid retrying ambiguous writes`.

### Cycle 5 — Recoverable settings import

- Confirmed BUG-005 with two failures against isolated temporary Hive boxes: a missing section cleared both boxes before a type error, and a failed write left the settings box empty.
- Validated both named settings sections before mutation and snapshot both boxes for coordinated rollback on any clear/write failure.
- Added `test/utils/storage_test.dart` covering missing-section rejection, rollback after write failure, and full replacement on valid import.
- Focused tests passed twice; focused analyzer reported no issues; format and diff checks passed.
- WebDAV's delete-before-upload behavior remains a separate confirmed candidate awaiting an injectable client test.
- Local commit: `acc92464c fix(settings): make imports recoverable`.

### Cycle 6 — Download resume integrity

- Confirmed BUG-006 with a loopback server: a 5-byte partial file became 21 bytes when the server legally ignored `Range` and returned the full 16-byte payload with HTTP 200.
- Deferred sink creation until after response validation; valid 206 must begin at the local offset, HTTP 200 truncates/restarts, matching 416 can confirm completion without appending, and mismatched/unexpected statuses preserve the partial file as failed.
- Added `test/services/download/download_manager_test.dart` with six temporary-directory/loopback cases.
- Focused tests passed; source and test analyzer passes; format and diff checks passed.
- Local commit: `af604131c fix(download): validate resumed responses`.

### Cycle 7 — Recoverable WebDAV backup replacement

- Confirmed BUG-007 with two in-memory WebDAV-operation tests. Before the fix, a simulated partial upload replaced the prior backup with three bytes, and the successful path began by deleting the target.
- Uploads now write to a unique sibling temporary path and replace the target only after the upload completes, using WebDAV MOVE with overwrite enabled; best-effort cleanup removes abandoned temporary files.
- Added `test/pages/webdav/webdav_test.dart` for failed-upload preservation and successful temporary-path replacement.
- Focused tests passed; focused analyzer reported no issues; format and diff checks passed.
- Local commit: `7825224ac fix(webdav): preserve backup during replacement`.

### Cycle 8 — Download preflight cancellation

- Confirmed BUG-008 with controllable danmaku and play-URL futures. Before the fix, pausing during either preflight allowed the stale operation to resolve the media/start a transfer, producing transfer/resolver counts of one instead of zero.
- Added an operation generation tied to the selected entry; pause/delete/new-selection invalidate delayed preflight continuations, stale status/error writes, and manager creation.
- Added `test/services/download/download_service_test.dart` with deterministic pause races for both preflight stages.
- Both focused tests and the complete download test directory passed (8 tests); source/test analyzers, format, and diff checks passed.
- Local commit: `d0434bc90 fix(download): honor pause during preflight`.

### Cycle 9 — Latest-only search suggestions

- Confirmed BUG-009 with controllable response futures. Before the fix, completing the newer query first and the older query last applied both values in that order; clearing during an in-flight request still returned the stale value.
- Added a small query-aware generation guard. Input changes invalidate active requests, obsolete debounced callbacks do not start network work, and only the current query may apply a response; a current empty response also clears prior suggestions.
- Added `test/pages/search/latest_suggestion_loader_test.dart` with out-of-order, in-flight-clear, and pending-debounce-clear cases.
- Focused tests passed; source/test analyzer reported no issues; format and diff checks passed.
- Local commit: `fb5250476 fix(search): ignore stale suggestion responses`.

### Cycle 10 — Cancel-safe image batch completion

- Confirmed BUG-010 with controllable batch futures. Before the fix, cancellation during fetch still invoked the completion/save callback once, and a pre-cancelled lazy task still started.
- Routed batch fetch completion through a cancellation-aware helper; cancellation is checked before task start, before entering the gallery/file-save phase, and between sequential desktop saves.
- Added `test/utils/cancellable_batch_test.dart` for mid-fetch cancellation, pre-cancellation, and normal completion.
- Focused tests passed; source/test analyzer reported no issues; format and diff checks passed.
- Local commit: `edca471a9 fix(images): stop cancelled batches before saving`.

### Cycle 11 — Restore article title parsing

- Confirmed BUG-011 with a failing factory test and a current successful `/x/article/view` response whose nonempty `title` was always parsed as null. History traced the omission to model-cleanup commit `279f21857`.
- Restored the declared title field to the constructor and `fromJson`; this supplies the reader summary when the optional action-bar metadata request is disabled.
- Added `test/models_new/article/article_view/data_test.dart`.
- Focused test passed; source/test analyzer reported no issues; format and diff checks passed.
- Local commit: `31ad9c612 fix(article): restore parsed titles`.

### Cycle 12 — Render all-search PGC groups

- Confirmed BUG-012 with a failing mixed-result factory test and a current public all-search sample containing both `media_bangumi` and `media_ft` groups. Before the fix, the film group was unmatched and the bangumi entries were flattened into a runtime type the view intentionally ignores.
- Corrected the duplicated switch label and retained each PGC response group as `List<SearchPgcItemModel>`, matching `SearchAllPanel`'s rendering contract.
- Added `test/models/search/result_test.dart` covering both group types and their season identities.
- Focused test passed; source/test analyzer reported no issues; format and diff checks passed.
- Local commit: `3c31e52a2 fix(search): render all PGC result groups`.

### Cycle 13 — Preserve authenticated WebView cookies

- Confirmed BUG-013 by tracing `clearCache: true` through the pinned iOS/macOS plugin: initial WebView setup asynchronously removes all default website-data types, including cookies, so opening authenticated notes/appeals/shop pages could immediately erase their login state. The incognito Geetest WebView issued the same global deletion.
- Centralized both settings policies and disabled automatic cache clearing; authenticated WebViews keep the shared cookie store, while Geetest remains incognito with cache/storage disabled. The existing explicit “clear cache” menu action is unchanged.
- Added `test/pages/webview/settings_test.dart` for both policies. Before the fix, both assertions observed `clearCache == true`.
- Focused tests passed; source/test analyzer reported no issues; format and diff checks passed. Native iOS/macOS runtime build remains environment-blocked as recorded above.
- Local commit: `8a4f286ce fix(webview): preserve shared cookies on open`.

### Cycle 14 — Latest-wins video episode setup

- Confirmed BUG-014 with a completer-backed request seam. Before the fix, selecting episode B while A was in flight left the started sequence at `[A]` instead of `[A, B]`; A's eventual response was interpreted through mutable B identifiers. Independent review additionally confirmed stale `setDataSource` completion could autoplay/run post-init work after invalidation.
- Added a serial latest-request runner that snapshots media/URL parameters, coalesces pending switches, suppresses stale results/errors, and preserves one-time resume/fullscreen intent across same-media refreshes. Player setup checks generation before, during, and after initialization; an obsolete setup pauses only while it still owns the exact active data source.
- Confirmed BUG-015 in the same identity path: unawaited SponsorBlock results had no episode guard. Its optional application predicate now uses the video generation plus controller liveness.
- Moved route progress into a request-scoped BVID/CID token so a replacement episode cannot inherit it.
- Added `test/pages/video/latest_request_runner_test.dart` with six ordering, failure, coalescing, side-work, and intent-preservation cases.
- Focused tests passed; controller/helper/mixin/test analyzer reported no issues; format and diff checks passed.
- Local commit: `d77a9c2b3 fix(video): make episode requests latest-wins`.

### Cycle 15 — Label-bound deep-link hosts

- Confirmed BUG-016 with a failing host-boundary test: both an attacker-controlled prefix (`evilbilibili.com`) and suffix (`bilibili.com.evil.test`) passed the previous `contains` checks.
- Replaced every general, short-link, dynamic, live, space, search, and music host check with an exact-domain-or-dot-subdomain predicate, including case and DNS trailing-dot normalization.
- Added `test/utils/domain_utils_test.dart`; the hostile boundary cases failed before the fix.
- Focused test passed; source/test analyzer reported no issues; format and diff checks passed.
- Local commit: `6de0a5528 fix(links): require label-bound official domains`.

### Cycle 16 — Authentication and diagnostic isolation

- Confirmed BUG-017 in a second network/privacy pass. Dio 5.10 defaults still printed authenticated request/response URIs and error objects even though method/header logging was disabled; both success and failure sentinel tests exposed all query credentials before the fix.
- Centralized the sole debug interceptor configuration and explicitly disabled requests, URLs, headers, bodies, responses, and errors. Both focused tests, analyzer, format, and diff checks passed.
- Confirmed BUG-018 from the multi-account settings flow: the remote confirmation always logged out the main account once, independent of the selected set. Added a per-account coordinator with explicit partial-failure behavior; three tests verify all-success, mixed server failure, and thrown-request cases.
- Confirmed BUG-019 by following the generated WebView origins into the Android and Windows cookie-manager contracts. Both platform branches received malformed origins. A pure normalization helper now produces `https://host/` consistently; three boundary tests pass.
- Confirmed BUG-020 with a standard copied Cookie header. Validation sent trimmed segments, but persistence reparsed the raw text into leading-space names and removed embedded equals signs. One shared parser now validates and supplies both representations; three regression tests pass.
- Independent focused validation reported no analyzer findings and clean format/diff checks for all four fixes.
- Local commits: `cff674b3c fix(http): suppress credential-bearing debug logs`, `b638d183a fix(accounts): repair logout and cookie targeting`, and `8551feb6d fix(login): parse pasted cookie headers safely`.

### Cycle 17 — Convergence, ownership, and final closure review

- Consolidated the remaining parallel audit passes across audio/session ownership, shared list/request ordering, lifecycle cleanup, DLNA, temporary media, settings, home tabs, accounts, async submissions/routes, video side requests, and downloads.
- Confirmed and fixed BUG-021 through BUG-053. Each production change was kept in a local atomic commit and backed by focused tests or a deterministic contract proof; the fixed-bug table above gives the exact evidence and commit mapping.
- Added/expanded deterministic coverage for audio initialization/open/session/media ownership, mandatory refresh ordering, mutation reconciliation, controller disposal, rich-picture upload failure, DLNA delayed startup, WebP initialization/temp cleanup/dialog cancel, settings semantic validation, home tabs, account identity/tombstones/history privacy, route ownership, stable list items, media side-request generations, account-bound actions, and download completion/delete interleavings.
- Closure review found the download-delete resurrection race and same-MID action-identity gap while those patches were still in progress; both received regressions and were fixed before freeze.
- The same closure review then confirmed OPEN-001 through OPEN-004. At the user's instruction, work stopped without modifying those paths.
- Final validation: `dart format --output=none --set-exit-if-changed .` checked 1341 files with 0 changes; `flutter test --no-pub` passed 139/139; `flutter analyze --no-pub` reported the exact baseline 37 info findings and no warning/error; `git diff --check` passed; `flutter build apk --debug --no-pub` produced `build/app/outputs/flutter-apk/app-debug.apk` in 30.1s.
- Local commits: `4a9733d2a`, `371b85f70`, `111fbb347`, `f884d52d0`, `11708a933`, `f43ae0cd7`, `4cc38e9b5`, `b0c9a1160`, `d50030954`, `ff6df05c4`, `86094e5ba`, `e56de3cff`, `9cbb16626`, `76e9541eb`, `caa8eb2d7`, `cdcbecb66`, `06626611f`, `45dbcfa5c`, `f24eb987f`, `9eae55089`, `4d73b9bd1`, `6ffd6ac57`, and `d6f2ed775`.
- Cycles 18–20 were not run. Consequently, the original three-consecutive-clean-cycle criterion is unmet and this report does not claim that all repository bugs were fixed.

# PiliPlus Full Audit Result

## 1. Executive Summary

- Audit window: baseline plus 17 major cycles on 2026-07-18; stopped at the user's request.
- Baseline: `c1aeaca09e24f67e75685c7744fd1aa0a94b439a` on `main`.
- Audit branch: `codex/full-audit-fixes`.
- Confirmed bugs fixed: 53, represented by 41 local atomic commits.
- Confirmed bugs deferred: 4 (OPEN-001 through OPEN-004).
- Suspected issues retained: 3 (CAND-008 through CAND-010).
- Automated coverage: baseline had no `test/` directory; final branch has 41 test files and 139 passing tests.
- Analyzer: no warnings or errors; the same 37 baseline info-level lints remain explained above.
- Android build: debug APK succeeds.
- Push/PR/release: none performed.
- Audit state report: intentionally untracked and excluded from all product commits.

## 2. Baseline Problems

- No automated test directory or regression coverage existed.
- Proxy setup weakened TLS policy; credential-bearing diagnostics and unsafe ambiguous-write retries were present.
- High-risk account, async ordering, lifecycle, player/audio ownership, download/file integrity, settings import, WebView, and list mutation paths lacked deterministic tests.
- Analyzer already contained 37 informational findings; none was an error/warning and none was mechanically changed.
- iOS/macOS and Windows/Linux platform builds were unavailable on this host as described under Environment Blockers.

## 3. Fixed Bugs

The authoritative per-bug record is the **Confirmed Bugs** table above. It lists severity, root-cause evidence, regression/validation status, and exact local commit for BUG-001 through BUG-053.

## 4. Tests Added

- 41 test files, 139 passing test cases, all introduced during the audit.
- Coverage families: HTTP/TLS/logging/retry; account/cookie/import/history identity; settings/model parsing; async guards/request ordering; route/lifecycle; video/audio/session ownership; download resume/cancel/complete/delete; WebDAV/temp/image/WebP; DLNA/platform entitlements; UI submission and reconciliation.
- Tests use fake adapters, loopback servers, completers, temporary directories, in-memory/temporary Hive boxes, and pure coordinators. No real user cache, credentials, or destructive live-service writes were used.

## 5. Commands Executed

Key baseline and final commands (focused tests/analyzers were also run after each cohesive fix):

```bash
git status --short
git rev-parse HEAD
git branch --show-current
flutter --version
dart --version
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze --no-pub
flutter test --no-pub
git diff --check
flutter build apk --debug --no-pub
gh issue list --repo MostlyHarmlessxyz/PiliPlus --state open --limit 100
gh pr list --repo MostlyHarmlessxyz/PiliPlus --state open --limit 100
gh run list --repo MostlyHarmlessxyz/PiliPlus --limit 30
```

## 6. Platform Validation Matrix

| Platform | Analyze | Tests | Build | Runtime | Notes |
|---|---|---|---|---|---|
| Android | Passed; 37 baseline infos only | 139/139 passed on host | Debug APK passed | Not device-smoke-tested | Gradle/plugin warnings are dependency migration notices, not build failures |
| iOS | Shared Dart analysis/tests passed | 139/139 host tests | Blocked | Not run | Full Xcode and CocoaPods unavailable |
| macOS | Shared Dart analysis/tests passed; entitlement policy test passed | 139/139 host tests | Blocked | Not run | Full Xcode and CocoaPods unavailable |
| Windows | Shared Dart analysis/tests passed | 139/139 host tests | Unsupported on macOS | Not run | Requires a Windows host |
| Linux | Shared Dart analysis/tests passed | 139/139 host tests | Unsupported on macOS | Not run | Requires a Linux host |
| Pad/large screen | Shared Dart analysis/tests passed | Relevant pure/widget tests passed | Covered by Android artifact only | Not run | Needs device/emulator layout smoke testing |

## 7. Remaining Risks

- Confirmed but deferred: OPEN-001 through OPEN-004, documented above with exact evidence and recommended regressions.
- Suspected: CAND-008 through CAND-010; do not change production code without the listed verification.
- Platform risk: native plugin/channel, signing, entitlement, cookie-store, background audio, and filesystem behavior still need supported-host/device runtime checks.
- Convergence risk: the requested stop occurred before three consecutive clean cycles; no claim of repository-wide bug exhaustion is made.

## 8. Environment Blockers

See **Environment Blockers** above. Android was fully buildable after configuring the pinned SDK; Apple desktop/mobile and Windows/Linux builds require other toolchains/hosts.

## 9. Unreviewed or Partially Reviewed Areas

- No major module was wholly omitted, but live authenticated service behavior and native runtime behavior were necessarily partial.
- The four deferred confirmed defects did not receive fixes or regressions.
- The final three planned clean cycles were cancelled by user instruction.

## 10. Local Commits

```text
964851a9f fix(http): preserve TLS validation when proxying
af5523a62 fix(http): redact credentials from error URLs
0a9ddb10f fix(accounts): pin request account for cookie persistence
aa2a033c6 fix(http): avoid retrying ambiguous writes
acc92464c fix(settings): make imports recoverable
af604131c fix(download): validate resumed responses
7825224ac fix(webdav): preserve backup during replacement
d0434bc90 fix(download): honor pause during preflight
fb5250476 fix(search): ignore stale suggestion responses
edca471a9 fix(images): stop cancelled batches before saving
31ad9c612 fix(article): restore parsed titles
3c31e52a2 fix(search): render all PGC result groups
8a4f286ce fix(webview): preserve shared cookies on open
d77a9c2b3 fix(video): make episode requests latest-wins
6de0a5528 fix(links): require label-bound official domains
cff674b3c fix(http): suppress credential-bearing debug logs
b638d183a fix(accounts): repair logout and cookie targeting
8551feb6d fix(login): parse pasted cookie headers safely
4a9733d2a fix(lists): queue mandatory refreshes
371b85f70 fix(ui): serialize async user actions
111fbb347 fix(audio): coordinate playback ownership
f884d52d0 fix(publish): clean up failed picture uploads
11708a933 fix(ui): complete page lifecycle cleanup
f43ae0cd7 fix(dlna): close late discovery resources
4cc38e9b5 fix(player): make WebP cancellation init-safe
b0c9a1160 fix(media): clean temporary export files
d50030954 fix(settings): reject unsafe imported values
ff6df05c4 fix(home): recover empty tab configurations
86094e5ba fix(macos): allow DLNA discovery in release
e56de3cff fix(accounts): isolate overlapping account switches
9cbb16626 fix(actions): coordinate resource mutations
76e9541eb fix(lists): bind async results to stable items
caa8eb2d7 fix(settings): validate remaining unsafe imports
cdcbecb66 fix(accounts): close transition privacy gaps
06626611f fix(logging): redact signed media URLs
45dbcfa5c fix(ui): bind async submissions to initiating routes
f24eb987f fix(lists): invalidate stale reads after mutations
9eae55089 fix(settings): reject invalid layout ratios
4d73b9bd1 fix(actions): bind mutations to account identity
6ffd6ac57 fix(download): preserve completion ownership
d6f2ed775 fix(player): resume after cancelled WebP export
```

## 11. Recommended Next Steps

1. Fix OPEN-001 first because it is the remaining cross-account credential risk; then OPEN-003, OPEN-002, and OPEN-004.
2. Run three fresh, independent clean audit cycles after those fixes.
3. Validate Apple builds/runtime with full Xcode/CocoaPods, then Windows/Linux builds on native hosts.
4. Run authenticated smoke tests with non-production test accounts for account switching, WebView cookies, media actions, background audio, downloads, and WebDAV.
5. Open a draft PR first; the branch is large despite atomic commits, so let CI and maintainers decide whether to review it whole or split by commit groups.

## 12. Final Git Snapshot

```text
git status --short
?? CODEX_AUDIT_REPORT.md

git branch --show-current
codex/full-audit-fixes

git rev-list --count c1aeaca09e24f67e75685c7744fd1aa0a94b439a..HEAD
41

git diff c1aeaca09e24f67e75685c7744fd1aa0a94b439a...HEAD --stat
177 files changed, 9187 insertions(+), 1435 deletions(-)
```
