# CHANGELOG

# 0.12.0 alpha

0.12.0 requires iOS8+ and Swift 2.0+.

Also note that due to a bug into Cocoapods 0.39, Akane is not compatible with Xcode 7.1+.

## Added

- "Native" binding. Use the new method ```bindings:viewModel``` from ```ViewComponent``` protocol.
- Command pattern support to communicate between View and ViewModel. Use ```RelayCommand``` or a custom one with ```Command``` protocol.
- Binding converters.

## Enhancements

- Removed deprecated methods. Some are still available and will be removed in future beta releases.
- Made Akane compatible with Swift only.
