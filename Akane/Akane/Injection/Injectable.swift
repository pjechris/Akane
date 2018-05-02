//
//  Injectable.swift
//  Akane
//
//  Created by pjechris on 31/12/2017.
//  Copyright © 2017 fr.akane. All rights reserved.
//

import Foundation

/// NOTE: This is alpha API, it might not work properly. Use it with caution.
public protocol Injectable {
    associatedtype Parameters

    init(resolver: DependencyResolver, parameters: Parameters)
}
