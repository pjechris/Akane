//
//  DependencyResolver.swift
//  Akane
//
//  Created by pjechris on 31/12/2017.
//  Copyright © 2017 fr.akane. All rights reserved.
//

import Foundation

public protocol DependencyResolver {
    func resolve<T: ComponentViewModel & Injectable>(_ type: T.Type, arguments: T.RuntimeDependencies) throws -> T
}

extension DependencyResolver {
    public func resolve<T: ComponentViewModel & Injectable>(_ type: T.Type, arguments: T.RuntimeDependencies) throws -> T {
        return T.init(resolver: self, arguments: arguments)
    }
}
