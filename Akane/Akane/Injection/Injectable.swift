//
//  Injectable.swift
//  Akane
//
//  Created by pjechris on 31/12/2017.
//  Copyright © 2017 fr.akane. All rights reserved.
//

import Foundation

public protocol Injectable {
    associatedtype RuntimeDependencies = Void

    init(resolver: DependencyResolver, arguments: RuntimeDependencies)
}
