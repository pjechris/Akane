//
// This file is part of Akane
//
// Created by JC on 10/01/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public enum CollectionElementCategory {
    case Cell(identifier: String)
    case Section(identifier: String, kind: String)
//    case Decoration
}

extension CollectionElementCategory : Hashable {
    public var hashValue : Int {
        switch(self) {
        case .Cell(let itemIdentifier):
            return itemIdentifier.hashValue
        case .Section(let sectionIdentifier, let sectionKind):
            return sectionIdentifier.hashValue ^ sectionKind.hashValue
        }
    }
}

public func ==(lhs: CollectionElementCategory, rhs: CollectionElementCategory) -> Bool {
    switch (lhs, rhs) {
    case (.Cell(let itemIdentifier1), .Cell(let itemIdentifier2)):
        return itemIdentifier1 == itemIdentifier2
    case(.Section(let sectionIdentifier1, let sectionKind1), .Section(let sectionIdentifier2, let sectionKind2)):
        return sectionKind1 == sectionKind2 && sectionIdentifier1 == sectionIdentifier2
    default:
        return false
    }
}

extension Dictionary {
    /// Find value associated to ```CollectionElementCategory``` key or create it
    /// - parameter key: a ```CollectionElementCategory``` key
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