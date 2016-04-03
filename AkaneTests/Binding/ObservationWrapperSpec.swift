//
// This file is part of Akane
//
// Created by JC on 27/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Quick
import Nimble
import Bond
@testable import Akane

class ObservationWrapperSpec : QuickSpec {
    override func spec() {
        var observer: ObservationWrapper<String?>!
        var value: Observable<String?>!

        beforeEach {
            value = Observable(nil)
            observer = ObservationWrapper(observable: value, attribute: { return $0 })
        }

        describe("bindTo") {
            var bindedItem: UILabel!

            beforeEach {
                bindedItem = UILabel()
                observer.bindTo(bindedItem.bnd_text)
            }

            context("when value changed") {
                it("should update the binding") {
                    value.next("Hello World")
                    expect(bindedItem.text) == "Hello World"
                }
            }

            context("when disposed") {
                it("should stop update the binding") {
                    observer.dispose()
                    value.next("the world is mine")
                    expect(bindedItem.text).to(beNil())
                }
            }
        }

        describe("convert") {
            it("should return the converted value") {
                let observer = observer.convert(UppercaseConverterStub.self)

                value.next("this is giant")
                expect(observer.value) == "THIS IS GIANT"
            }

            context("when chaining") {
                it ("should return the last converted value") {
                    let observer = observer
                        .convert(UppercaseConverterStub.self)
                        .convert(SpacePreserverStub.self)

                    value.next("there is no space left")
                    expect(observer.value) == "THERE+IS+NO+SPACE+LEFT"
                }
            }
        }
    }
}

struct SpacePreserverStub : Converter {
    typealias ValueType = String?
    typealias ConvertValueType = String?

    func convert(value: ValueType) -> ConvertValueType {
        return value?.stringByReplacingOccurrencesOfString(" ", withString: "+")
    }
}

struct UppercaseConverterStub : Converter {
    typealias ValueType = String?
    typealias ConvertValueType = String?

    func convert(value: ValueType) -> ConvertValueType {
        return value?.uppercaseString
    }
}