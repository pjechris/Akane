//
// This file is part of Akane
//
// Created by JC on 04/04/16.
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
        var observer: AnyObservation<String?>!

        beforeEach {
            observer = AnyObservation(value: nil)
        }

        describe("bindTo") {
            var bindedItem: UILabel!

            beforeEach {
                bindedItem = UILabel()
                observer.bind(to: bindedItem.bnd_text)
            }

            context("when value changed") {
                it("should update the binding") {
                    observer.put("Hello World")
                    expect(bindedItem.text) == "Hello World"
                }
            }
        }

        describe("unbind") {
            var bindedItem: UILabel!

            beforeEach {
                bindedItem = UILabel()
                observer.bind(to: bindedItem.bnd_text)
            }

            it("should stop update the binding") {
                observer.unobserve()
                observer.put("the world is mine")
                expect(bindedItem.text).to(beNil())
            }
        }

        describe("convert") {
            it("should return the converted value") {
                var result: String? = nil
                let _ = observer.convert { value -> String? in
                    result = value?.uppercased()

                    return result
                }

                observer.put("this is giant")
                expect(result) == "THIS IS GIANT"
            }

            context("when chaining") {
                it ("should return the last converted value") {
                    var result: String? = nil
                    let _ = observer.convert { value -> String? in
                        result = value?
                            .uppercased()
                            .replacingOccurrences(of: " ", with: "+")

                        return result
                    }

                    observer.put("there is no space left")
                    expect(result) == "THERE+IS+NO+SPACE+LEFT"
                }
            }
        }
    }
}
