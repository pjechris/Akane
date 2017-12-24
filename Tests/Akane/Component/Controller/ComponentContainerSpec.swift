//
//  ComponentContainerSpec.swift
//  Akane
//
//  Created by pjechris on 21/06/2017.
//  Copyright © 2017 fr.akane. All rights reserved.
//

import Foundation
import Nimble
import Quick
@testable import Akane

class ComponentContainerSpec : QuickSpec {
    override func spec() {
        var container: ComponentControllerStub!

        beforeEach {
            container = ComponentControllerStub(nibName: nil, bundle: nil)
        }

        describe("component(for:)") {
            var view: ComponentViewMock!

            beforeEach {
                view = ComponentViewMock()
            }

            context("when controller does not exist") {
                it("creates it") {
                    let component = container.component(for: view)

                    expect(type(of: component)) === ComponentViewMock.Wrapper.self
                }
            }
        }
    }
}

class ComponentControllerStub : UIViewController, ComponentController {
    typealias ViewType = ComponentViewMock
}

class ComponentViewMock : UIView, ComponentDisplayable, Wrapped {
    typealias ViewModelType = ComponentViewModelMock
    typealias Wrapper = ComponentControllerStub

    func bindings(_ observer: ViewObserver, viewModel: ComponentViewModelMock) {

    }
}

class ComponentViewModelMock : ComponentViewModel {
    init() {

    }
}
