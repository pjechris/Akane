//
//  AppContext.swift
//  Akane
//
//  Created by pjechris on 31/12/2017.
//  Copyright © 2017 fr.akane. All rights reserved.
//

import Foundation

public protocol Context: ComponentProvider {
    var resolver: DependencyResolver? { get }
}

extension ComponentProvider where Self: Context {
    public func provide<T: ComponentViewModel & Injectable>(_ type: T.Type, parameters: T.Parameters) -> T? {
        guard let resolver = self.resolver else {
            return nil
        }

        return T.init(resolver: resolver, parameters: parameters)
    }
}
