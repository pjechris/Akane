//
//  DependencyResolver.swift
//  Akane
//
//  Created by pjechris on 31/12/2017.
//  Copyright © 2017 fr.akane. All rights reserved.
//

import Foundation

// ComponentResolver
public protocol DependencyResolver {
    func resolve<T: ComponentViewModel & Paramaterized & Injectable>(_ type: T.Type, parameters: T.InjectionParameters) -> T
}

extension DependencyResolver {
    public func resolve<T: ComponentViewModel & Paramaterized & Injectable>(_ type: T.Type, parameters: T.InjectionParameters) -> T {
        return T.init(resolver: self, parameters: parameters)
    }
}
