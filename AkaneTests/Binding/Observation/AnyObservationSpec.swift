//
// This file is part of Akane
//
// Created by JC on 23/05/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Nimble
import Quick
@testable import Akane

class AnyObservationSpec : QuickSpec {
    override func spec() {
        var observation: AnyObservation<String?>!
        var binding: BindingMock!

        beforeEach {
            observation = AnyObservation(value: "hello world")
            binding = BindingMock()
        }

        describe("bindTo") {
            it("sets value to binding") {
                observation.bindTo(binding)

                expect(binding.receivedBinding) == "hello world"
            }

            context("with conversion") {
                context("with no option") {
                    it("binds converted value") {
                        observation.convert(SimpleConverter.self).bindTo(binding)

                        expect(binding.receivedBinding) == "hey hello world!"
                    }
                }

                context("with option") {
                    it("binds converted value") {
                        observation
                            .convert(ComplexConverter.self) { .Uppercase }
                            .bindTo(binding)

                        expect(binding.receivedBinding) == "HEY HELLO WORLD!"
                    }
                }
            }
        }
    }
}

extension AnyObservationSpec {
    class BindingMock : Bindable {
        var receivedBinding: String? = nil

        func advance() -> (String? -> Void) {
            return {
                self.receivedBinding = $0
            }
        }
    }

    class SimpleConverter: Converter {
        required init() {

        }

        func convert(value: String?) -> String? {
            return value.map { "hey \($0)!" }
        }
    }

    class ComplexConverter: Converter, ConverterOption {
        enum ConvertOptionType {
            case Lowercase
            case Uppercase
        }

        let option: ConvertOptionType

        convenience required init() {
            self.init(options: .Lowercase)
        }

        required init(options: ConvertOptionType) {
            self.option = options
        }

        func convert(value: String?) -> String? {
            return value.map {
                switch(self.option) {
                case .Lowercase:
                    return $0.lowercaseString
                case .Uppercase:
                    return $0.uppercaseString
                }
            }
        }
    }
}