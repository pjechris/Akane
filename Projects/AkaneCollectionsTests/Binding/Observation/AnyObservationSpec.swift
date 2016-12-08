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
@testable import AkaneCollections

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
                observation.bind(to: binding)

                expect(binding.receivedBinding) == "hello world"
            }

            context("with conversion") {
                context("with no option") {
                    it("binds converted value") {
                        observation.convert(AddExclamationConverter.self).bind(to: binding)

                        expect(binding.receivedBinding) == "hey hello world!"
                    }
                }

                context("with option") {
                    it("binds converted value") {
                        observation
                            .convert(ComplexConverter.self) { .uppercase }
                            .bind(to: binding)

                        expect(binding.receivedBinding) == "HELLO WORLD"
                    }
                }
            }
        }
    }
}

extension AnyObservationSpec {
    class BindingMock : Bindable {
        var receivedBinding: String? = nil

        func advance() -> ((String?) -> Void) {
            return {
                self.receivedBinding = $0
            }
        }
    }

    class AddExclamationConverter: Converter {
        required init() {

        }

        func convert(_ value: String?) -> String? {
            return value.map { "hey \($0)!" }
        }
    }

    class ComplexConverter: Converter, ConverterOption {
        enum ConvertOptionType {
            case lowercase
            case uppercase
        }

        let option: ConvertOptionType

        convenience required init() {
            self.init(options: .lowercase)
        }

        required init(options: ConvertOptionType) {
            self.option = options
        }

        func convert(_ value: String?) -> String? {
            return value.map {
                switch(self.option) {
                case .lowercase:
                    return $0.lowercased()
                case .uppercase:
                    return $0.uppercased()
                }
            }
        }
    }
}
