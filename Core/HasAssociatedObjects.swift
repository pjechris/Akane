//
//  HasAssociatedObjects.swift
//
//  Created by ToKoRo on 2015-11-07.
//

import Foundation

public class AssociatedObjects: NSObject {
    
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

public protocol HasAssociatedObjects {
    var associatedObjects: AssociatedObjects { get }
}

private var AssociatedObjectsKey: UInt8 = 0

extension HasAssociatedObjects where Self: AnyObject {
    public var associatedObjects: AssociatedObjects {
        guard let associatedObjects = objc_getAssociatedObject(self, &AssociatedObjectsKey) as? AssociatedObjects else {
            let associatedObjects = AssociatedObjects()
            objc_setAssociatedObject(self, &AssociatedObjectsKey, associatedObjects, .OBJC_ASSOCIATION_RETAIN)
            return associatedObjects
        }
        return associatedObjects
    }
}
