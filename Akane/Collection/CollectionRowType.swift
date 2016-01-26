//
// This file is part of Akane
//
// Created by JC on 10/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

enum CollectionRowType {
    case Item(identifier: String)
    case Section(identifier: String, kind: String)
}

extension CollectionRowType : Hashable {
    var hashValue : Int {
        switch(self) {
        case .Item(let itemIdentifier):
            return itemIdentifier.hashValue
        case .Section(let sectionIdentifier, let sectionKind):
            return sectionIdentifier.hashValue ^ sectionKind.hashValue
        }
    }
}

func ==(lhs: CollectionRowType, rhs: CollectionRowType) -> Bool {
    switch (lhs, rhs) {
    case (.Item(let itemIdentifier1), .Item(let itemIdentifier2)):
        return itemIdentifier1 == itemIdentifier2
    case(.Section(let sectionIdentifier1, let sectionKind1), .Section(let sectionIdentifier2, let sectionKind2)):
        return sectionKind1 == sectionKind2 && sectionIdentifier1 == sectionIdentifier2
    default:
        return false
    }
}

extension Dictionary {
    /// Find value associated to ```CollectionRowType``` key or create it
    /// - parameter key: a ```CollectionRowType``` key
    /// - parameter create: called when no value was found for ```key```. Return a new value to associate with
    /// - returns: found ```Value``` or a created one
    mutating func findOrCreate(key: Key, @noescape create: () -> Value) -> Value {
        guard let element = self[key] else {
            let element = create()

            self[key] = element

            return element
        }

        return element
    }
}