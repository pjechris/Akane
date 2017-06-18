//
// This file is part of Akane
//
// Created by JC on 16/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol Identifiable {
    var reuseIdentifier: String { get }
}

public struct VoidSection : Identifiable {
    public var reuseIdentifier: String { return "NoSection" }

    fileprivate init() { }
}

/// Provides collection data for display
public protocol DataSource {
    /// type of section. It is intended to be used as a associated value enum
    associatedtype Section: Identifiable = VoidSection
    /// section view model
    associatedtype SectionViewModelType : ComponentViewModel = Void
    /// type of 'row'. It is intended to be used as a associated value enum
    associatedtype Item: Identifiable
    /// row/item view model
    associatedtype ItemViewModelType : ComponentViewModel

    /// Ask the number of sections available into the data
    func numberOfSections() -> Int

    /// Ask the number of items contained into a section
    func numberOfItemsInSection(_ section: Int) -> Int

    func section(at index: Int) -> Section
    func viewModel(for item: Section) -> SectionViewModelType?

    func item(at indexPath: IndexPath) -> Item
    func viewModel(for item: Item) -> ItemViewModelType?
}

public extension DataSource where Section == VoidSection {
    /// returns one section
    func numberOfSections() -> Int {
        return 1
    }

    func section(at index: Int) -> Section {
        return VoidSection()
    }

    func viewModel(for item: Section) -> SectionViewModelType? {
        return nil
    }
}

