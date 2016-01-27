# CHANGELOG

# 0.12.0 beta 1 [WIP]

TL;DR Support for binding with TableView was added. Some important features are missing and will be added in beta 2.

## Added

- [Collection] DataSource protocol for table views. It is very similar to the one provided by Apple while emphasis it
- [Collection] View Models protocols to interact with a collection dataset.
- [Collection] TableView templates to register ```ComponentViewModel``` instances on ```UITableView```
- [Collection] TableView layout system
- [Binding] Added `bindTo` on optional `Command`

## Enhancements

- Renamed ```ViewModel``` as ```ComponentViewModel``` for consistency with other related protocols (```ComponentView``` and ```ComponentController```)

# 0.12.0 alpha 2

Akane is now compatible with Xcode 7.1+.

## Added

## Enhancements

- All protocols were re-written in Swift
- ViewComponent was renamed ComponentView
- Presenter was renamed ComponentController

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
