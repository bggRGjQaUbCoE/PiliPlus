# Danmaku Font Size Scaling for Merged Danmaku

## Overview

This feature implements font size scaling for merged duplicate danmaku, similar to Pakku.js. When multiple identical danmaku are merged together, the font size increases logarithmically based on the number of merged items, making popular danmaku more visually prominent.

## Implementation Status

### ✅ Fully Implemented

This feature is now **fully functional** with all components implemented:

1. **Font Size Calculation Logic** (`lib/pages/danmaku/controller.dart`)
   - Added `_calcEnlargeRate()` method implementing the Pakku.js formula: `count <= 5 ? 1.0 : log(count) / log(5)`
   - Added `_calcEnlargedFontSize()` method to calculate the final scaled font size
   - Modified `handleDanmaku()` to calculate and store enlarged font sizes in `DanmakuElem.fontsize` field during danmaku merging
   - Base font sizes are cached to optimize performance

2. **canvas_danmaku Package Modifications** (`packages/canvas_danmaku/`)
   - Added `fontSize` field to `DanmakuContentItem` class
   - Modified `generateParagraph()` in `utils.dart` to use per-item fontSize
   - Modified `recordDanmakuImage()` in `utils.dart` to render with per-item fontSize
   - Package vendored locally to enable these modifications

3. **View Integration** (`lib/pages/danmaku/view.dart`)
   - Updated to pass `e.fontsize` when creating `DanmakuContentItem`
   - Merged danmaku now render with scaled font size

## Formula

```dart
enlargeRate = count <= 5 ? 1.0 : log(count) / log(5)
enlargedFontSize = baseFontSize * enlargeRate
```

## Scaling Examples
- 1-5 identical danmaku: 1.0x (base size, e.g., 25px)
- 10 identical danmaku: 1.43x (e.g., ~36px)
- 20 identical danmaku: 1.86x (e.g., ~47px)
- 50 identical danmaku: 2.43x (e.g., ~61px)
- 100 identical danmaku: 2.86x (e.g., ~72px)

## How It Works

1. When danmaku are processed, identical messages are merged together and counted
2. For each merged danmaku, the enlarged font size is calculated based on the count
3. The calculated font size is stored in `DanmakuElem.fontsize`
4. When rendering, the custom `fontSize` is passed to `DanmakuContentItem`
5. The canvas_danmaku renderer uses this custom size (or falls back to global size if not provided)

## Testing

To test the feature:

1. Enable danmaku merging in PiliPlus settings
2. Play a video with many duplicate danmaku (popular videos work well)
3. Observe that merged danmaku appear progressively larger based on count:
   - Count ≤ 5: Normal size
   - Count > 5: Progressively larger, following logarithmic scaling
4. The `(count)` prefix scales proportionally with the danmaku text

## Technical Details

### Modified Files

**PiliPlus:**
- `lib/pages/danmaku/controller.dart`: Font size calculation logic
- `lib/pages/danmaku/view.dart`: Pass fontSize to renderer
- `pubspec.yaml`: Changed canvas_danmaku to local package

**canvas_danmaku (vendored in packages/canvas_danmaku/):**
- `lib/models/danmaku_content_item.dart`: Added fontSize field
- `lib/utils/utils.dart`: Use per-item fontSize in rendering

## References

- Original feature request: [增加重复弹幕合并时弹幕字体随重复数量增多而增大的功能]
- Pakku.js implementation: https://github.com/xmcp/pakku.js/
- Pakku.js enlarge rate formula: `count<=5 ? 1 : (Math.log(count) / MATH_LOG5)`
- canvas_danmaku original repository: https://github.com/bggRGjQaUbCoE/canvas_danmaku
