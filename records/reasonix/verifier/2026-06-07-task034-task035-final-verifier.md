# Verifier Report — Task-034 / Task-035 Final

**Date:** 2026-06-07  
**Verifier:** Reasonix  
**Review Owner:** Codex  

---

## 1. Expected Commit SHA

`aecfe372537e586d692d5e462f9ee02457801035`

---

## 2. CI Smoke Run — `27089059575`

| Field | Value |
|---|---|
| Workflow | `PiliAvalon CI` |
| Status | `completed` |
| Conclusion | `success` ✅ |
| Head SHA | `aecfe372537e586d692d5e462f9ee02457801035` ✅ |
| Head Branch | `production` |
| Event | `workflow_dispatch` |

**Verdict:** Completed success. SHA matches expected.

---

## 3. Android Prerelease Run — `27089383689`

| Field | Value |
|---|---|
| Workflow | `Build` |
| Status | `completed` |
| Conclusion | `success` ✅ |
| Head SHA | `aecfe372537e586d692d5e462f9ee02457801035` ✅ |
| Head Branch | `production` |
| Event | `workflow_dispatch` |

**Verdict:** Completed success. SHA matches expected.

---

## 4. Release — `v2.0.9-task-034-035-candidate`

| Field | Value |
|---|---|
| Draft | `false` ✅ |
| Prerelease | `true` ✅ |
| Target commitish | `aecfe372537e586d692d5e462f9ee02457801035` ✅ |
| Created | 2026-06-07T09:47:12Z |

### APK Assets (3 total)

| # | Filename | Size | SHA-256 (asset digest) |
|---|---|---|---|
| 1 | `PiliAvalon_android_2.0.8-aecfe3725+5113_arm64-v8a.apk` | 25.9 MB | `aaecbd8c…` |
| 2 | `PiliAvalon_android_2.0.8-aecfe3725+5113_armeabi-v7a.apk` | 25.8 MB | `dd16bb31…` |
| 3 | `PiliAvalon_android_2.0.8-aecfe3725+5113_x86_64.apk` | 26.9 MB | `bf04f3fc…` |

**APK count:** 3  
**Architectures:** arm64-v8a, armeabi-v7a, x86_64

---

## 5. Signing Fingerprint Evidence

Present in release body ✅

All three APKs share the same SHA-256 signing certificate fingerprint:

```
0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051
```

The release body also documents:
- applicationId: `com.example.piliplus`
- Cover-install verification requirements

---

## 6. Overall Verdict

| Check | Result |
|---|---|
| CI run completed success | ✅ |
| Android prerelease run completed success | ✅ |
| Release is non-draft, prerelease | ✅ |
| Release targets expected SHA | ✅ |
| APK assets present (3) | ✅ |
| Signing fingerprint evidence present | ✅ |

**Status: ALL CHECKS PASSED**

---

## 7. Risks / Unknowns

- Version string in APK filenames is `2.0.8-aecfe3725+5113` while the release tag is `v2.0.9-task-034-035-candidate` — this is a minor version-number mismatch between the tag (2.0.9) and the embedded APK version (2.0.8). This may be intentional (tag bumps for CI purposes) but should be noted.
- No download counts on any APK assets (all at 0) — confirms this is a fresh prerelease, not previously distributed.
