//
//  HasAssociatedObjects.swift
//
//  Created by ToKoRo on 2015-11-07.
//

import Foundation

public class _AssociatedObjects: NSObject {
    
    public var dictionary: [String: Any] = [:]
    
    public var value: Any? {
        get {
            return self.dictionary[""]
        }
        set {
            self.dictionary[""] = newValue ?? ""
        }
    }
    
    public subscript(key: String) -> Any? {
        get {
            return self.dictionary[key]
        }
        set {
            self.dictionary[key] = newValue
        }
    }
    
    public func removeAll() {
        self.dictionary.removeAll()
    }
    
}

public protocol _HasAssociatedObjects {
    var _associatedObjects: _AssociatedObjects { get }
}

private var _AssociatedObjectsKey: UInt8 = 0

public extension _HasAssociatedObjects where Self: AnyObject {
    var associatedObjects: _AssociatedObjects {
        guard let associatedObjects = objc_getAssociatedObject(self, &_AssociatedObjectsKey) as? _AssociatedObjects else {
            let associatedObjects = _AssociatedObjects()
            objc_setAssociatedObject(self, &_AssociatedObjectsKey, associatedObjects, .OBJC_ASSOCIATION_RETAIN)
            return associatedObjects
        }
        return associatedObjects
    }
}
