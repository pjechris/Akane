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

        describe("set viewModel") {
            beforeEach {

            }

            it("calls didLoadComponent") {
                // To make sure right method is called even if we don't have precie class type
                let unkonwnController = viewController as ComponentController

                unkonwnController.viewModel = ViewModelMock()

                expect(viewController.receivedDidLoadComponent) == true
            }

            it("calls makeBindings") {
                viewController.viewModel = ViewModelMock()

                expect(viewController.countMakeBindings) == 1
            }
        }

        describe("set viewModel multiple times") {
            it("calls makeBindings multiple times") {
                let count = viewController.countMakeBindings
                let setNb: UInt = 3

                for _ in 1...setNb {
                    viewController.viewModel = ViewModelMock()
                }

                expect(viewController.countMakeBindings) == count + setNb
            }

            it("makeBindings calls == stopBindings calls") {
                for _ in 1...3 {
                    viewController.viewModel = ViewModelMock()

                    expect(viewController.countMakeBindings) == viewController.countStopBindings
                }
            }
        }
    }
}

extension ComponentViewControllerSpec {
    class ComponentViewControllerMock : ComponentViewController {
        var receivedDidLoadComponent: Bool = false
        var countMakeBindings: UInt = 0
        var countStopBindings: UInt = 0
        var stubIsViewLoaded: Bool? = nil

        override func didLoadComponent() {
            self.receivedDidLoadComponent = true
        }

        override func isViewLoaded() -> Bool {
            return self.stubIsViewLoaded ?? super.isViewLoaded()
        }

        func makeBindings() {
            self.countMakeBindings += 1
        }

        func stopBindings() {
            self.countStopBindings += 1
        }
    }

    class ViewModelMock : ComponentViewModel {

    }
}