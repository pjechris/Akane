//
//  DisplayObservationTests.swift
//  AkaneTests
//
//  Created by pjechris on 15/01/2018.
//  Copyright © 2018 fr.akane. All rights reserved.
//

import Foundation
import Nimble
import Quick
@testable import Akane

class DisplayObservationTests : QuickSpec {

    override func spec() {
        var observation: DisplayObservationStub!
        var container: ContainerMock!
        var ctx: ContextMock!

        beforeEach {
            container = ContainerMock()
            ctx = ContextMock()
            let observer = ViewObserver(container: container, context: ctx)

            observation = DisplayObservationStub(view: ViewMock(frame: .zero),
                                                 container: container,
                                                 observer: observer)
        }

        describe("to(params:)") {
            context("view is of type Wrapped") {
                beforeEach {
                    observation.to(params: ViewModelMock())
                }

                it("asks container for component") {
                    expect(container.componentForViewCalled) == 1
                }
            }

            context("view model is injectable") {
                it("injects view model") {
                    observation.to(params: ())
                    expect(ctx.resolvedCalledCount) == 1
                }

                context("view model injected") {
                    var viewModel: ViewModelMock!

                    beforeEach {
                        viewModel = ViewModelMock()
                        observation.view.params = viewModel
                    }

                    it("re-uses view model") {
                        observation.to(params: ())
                        expect(observation.view.params) === viewModel
                    }
                }
            }
        }
    }
}

extension DisplayObservationTests {
    class DisplayObservationStub : DisplayObservation<ViewMock> {
        
    }

    class ContextMock : Context {
        private(set) var resolvedCalledCount = 0

        func resolve<T>(_ type: T.Type, parameters: T.InjectionParameters) -> T where T : ComponentViewModel, T : Injectable, T : Paramaterized {
            self.resolvedCalledCount += 1
            return T.init(resolver: self, parameters: parameters)
        }
    }

    class ContainerMock : UIViewController, ComponentContainer {
        var componentForViewCalled = 0

        func component<View: Wrapped>(for view: View) -> View.Wrapper {
            self.componentForViewCalled += 1
            return View.Wrapper.init(coder: NSCoder.empty())!
        }
    }

    class ViewModelMock : ComponentViewModel, Injectable, Paramaterized {
        typealias Parameters = Void

        var params: Void

        required convenience init(resolver: DependencyResolver, parameters: Void) {
            self.init()
        }

        init() {
            self.params = ()
        }
    }

    class ViewMock : UIView, ComponentDisplayable, Wrapped {
        typealias Wrapper = ComponentMock

        func bindings(_ observer: ViewObserver, params: ViewModelMock) {
            
        }
    }

    class ComponentMock : UIViewController, ComponentController {
        typealias ViewType = ViewMock
    }
}
