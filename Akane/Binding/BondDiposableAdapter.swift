//
//  SimpleBinding.swift
//  Akane
//
//  Created by JC on 05/11/15.
//  Copyright © 2015 fr.akane. All rights reserved.
//

import Foundation
import Bond

class BondDisposableAdapter : Disposable {
    let disposable: DisposableType

    init(_ disposable: DisposableType) {
        self.disposable = disposable
    }

    func dispose() {
        self.disposable.dispose()
    }
}