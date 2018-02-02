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
            it("binds on view") {
                observation.to(params: ())
                expect(observation.view.bindCalled) == 1
            }

            context("view is of type Wrapped") {
                it("asks container for component") {
                    observation.to(params: ViewModelMock())
                    expect(container.componentForViewCalled) == 1
                }
            }

            context("view model is injectable") {
                it("injects/resolves view model") {
                    observation.to(params: ())
                    expect(ctx.resolvedCalledCount) == 1
                }

                context("view model injected") {
                    var viewModel: ViewModelMock!

                    beforeEach {
                        viewModel = ViewModelMock()
                        observation.view.params = viewModel
                    }

                    it("binds with existing view model") {
                        observation.view.bindChecker = { _, params in
                            expect(params) === viewModel
                        }

                        observation.to(params: ())
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

        var bindCalled = 0
        var bindChecker: ((ViewObserver, DisplayObservationTests.ViewModelMock) -> ())? = nil

        func bindings(_ observer: ViewObserver, params: ViewModelMock) {
            
        }

        func bind(_ observer: ViewObserver, params: DisplayObservationTests.ViewModelMock) {
            self.bindChecker?(observer, params)
            self.bindCalled += 1
        }
    }

    class ComponentMock : UIViewController, ComponentController {
        typealias ViewType = ViewMock
    }
}
