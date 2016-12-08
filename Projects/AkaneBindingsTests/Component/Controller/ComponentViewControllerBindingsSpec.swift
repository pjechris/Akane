//
// This file is part of Akane
//
// Created by Simone Civetta on 22/11/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

import Foundation
import Nimble
import Quick
@testable import AkaneBindings

class ComponentViewControllerBindingsSpec : QuickSpec {
    override func spec() {
        var viewController: ComponentViewControllerMock!
        
        beforeEach {
            viewController = ComponentViewControllerMock(nibName: nil, bundle: nil)
        }
        
        describe("makeBindings") {
            beforeEach {
                viewController.view = ViewMock()
                viewController.viewModel = ViewModelMock()
            }
            
            it("sets observerCollection") {
                expect(viewController.componentView?.observerCollection).toNot(beNil())
            }
            
            it("sets componentLifecycle") {
                expect(viewController.componentView?.componentLifecycle) === viewController
            }
        }
        
        describe("set viewModel") {
            beforeEach {
                
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

extension ComponentViewControllerBindingsSpec {
    class ComponentViewControllerMock : ComponentViewController {
        var receivedDidLoadComponent: Bool = false
        var countMakeBindings: UInt = 0
        var stubIsViewLoaded: Bool? = nil
        
        override func didLoadComponent() {
            self.receivedDidLoadComponent = true
        }
        
        override var isViewLoaded: Bool {
            return self.stubIsViewLoaded ?? super.isViewLoaded
        }
        
        // FIXME
        // can't overload makeBindings
        override func didSetViewModel() {
            self.countMakeBindings += 1
            super.didSetViewModel()
        }
    }
    
    class ViewMock : UIView, ViewObserver {
        func bindings(viewModel: AnyObject) {
            
        }
        
        func bindings(_ observer: ViewObserver, viewModel: AnyObject) {
            
        }
    }
    
    class ViewModelMock : ComponentViewModel {
        
    }
}
