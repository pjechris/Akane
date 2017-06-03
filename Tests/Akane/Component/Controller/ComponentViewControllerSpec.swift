//
// This file is part of Akane
//
// Created by JC on 18/05/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Nimble
import Quick
@testable import Akane

class ComponentViewControllerSpec : QuickSpec {
    override func spec() {
        var viewController: ComponentViewControllerMock!

        beforeEach {
            viewController = ComponentViewControllerMock(nibName: nil, bundle: nil)
        }

        describe("set view") {
            beforeEach {
                viewController.view = ViewMock()
            }

            it("sets componentView") {
                expect(viewController.componentView).toNot(beNil())
            }
        }

        describe("set viewModel") {
            beforeEach {

            }

            it("calls didLoadComponent") {
                // To make sure right method is called even if we don't have precie class type
                let unkonwnController = viewController as AnyComponentController

                unkonwnController.setup(viewModel: ViewModelMock())

                expect(viewController.receivedDidLoadComponent) == true
            }

            it("calls makeBindings") {
                viewController.viewModel = ViewModelMock()

                expect(viewController.countMakeBindings) == 1
            }
        }

        describe("set viewModel multiple times") {
            let setNb: UInt = 3

            beforeEach {
                for _ in 1...setNb {
                    viewController.viewModel = ViewModelMock()
                }
            }

            it("calls makeBindings multiple times") {
                expect(viewController.countMakeBindings) == setNb
            }
        }
    }
}

extension ComponentViewControllerSpec {
    class ComponentViewControllerMock : UIViewController, ComponentController {
        typealias ViewType = ViewMock

        var receivedDidLoadComponent: Bool = false
        var countMakeBindings: UInt = 0
        var stubIsViewLoaded: Bool? = nil

        // FIXME
        // can't overload makeBindings
        func didLoadComponent() {
            self.receivedDidLoadComponent = true
            self.countMakeBindings += 1
        }

        override var isViewLoaded: Bool {
            return self.stubIsViewLoaded ?? super.isViewLoaded
        }
    }

    class ViewMock : UIView, ComponentView {
        typealias ViewModelType = ViewModelMock

        func bindings(_ observer: ViewObserver, viewModel: ViewModelMock) {
            
        }
    }

    class ViewModelMock : ComponentViewModel {

    }
}
