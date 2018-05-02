//
//  DependencyResolver.swift
//  Akane
//
//  Created by pjechris on 31/12/2017.
//  Copyright © 2017 fr.akane. All rights reserved.
//

import Foundation

public protocol DependencyResolver {
    func resolve<T>() -> T?
    func resolve<T, Arg1>(arguments: Arg1) -> T?
    func resolve<T, Arg1, Arg2>(arguments: Arg1, _ arg2: Arg2) -> T?
}

/// NOTE: This is alpha API, it might not work properly. Use it with caution.
public protocol ComponentProvider {
    func provide<T: ComponentViewModel & Injectable>(_ type: T.Type, parameters: T.Parameters) -> T?
}
