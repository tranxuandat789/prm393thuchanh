# Performance & Optimization Report

## 1. Issue Addressed
- **Symptoms**: The application experienced UI freezes during heavy computations, and high memory usage when displaying massive lists.
- **Root Cause**: Running intensive mathematical iterations on the main isolate blocked the rendering thread. Rendering 10,000 items simultaneously using a column/basic list overwhelmed memory.

## 2. Optimizations Applied

### A. List Rendering
- **Before**: Static list or non-lazy `ListView`.
- **After**: Implemented `ListView.builder`.
- **Impact**: Reduced initial load time and significantly decreased memory footprint. Flutter now only instantiates widgets currently visible on the screen.

### B. Widget Rebuild Prevention
- **Before**: New widget instances generated per frame for list items.
- **After**: Factored out `ListItemWidget` with a `const` constructor.
- **Impact**: Substantial reduction in GC (Garbage Collection) pauses and faster frame rendering because constant widgets are skipped during the rebuild tree traversal.

### C. UI Thread Non-Blocking (Isolates)
- **Before**: `_heavyComputation()` invoked synchronously.
- **After**: Used `compute(_heavyComputation, iterations)` to span a new Isolate.
- **Impact**: UI remains 100% responsive (animations and progress indicators run smoothly at 60Hz) while the heavy math runs in the background.

## 3. Release Build
The application was built using `--release` mode.
- Enables tree-shaking (removing unused code).
- Compiles Dart to AOT (Ahead-of-Time) machine code.
- Reduces APK size and speeds up startup execution significantly.
