//
//  Injectable.swift
//  Akane
//
//  Created by pjechris on 31/12/2017.
//  Copyright © 2017 fr.akane. All rights reserved.
//

import Foundation

public protocol Injectable {
    associatedtype InjectionParameters = Void

    init(resolver: DependencyResolver, parameters: InjectionParameters)
}

extension Injectable where Self : Paramaterized {
    public typealias InjectionParameters = Parameters
}
