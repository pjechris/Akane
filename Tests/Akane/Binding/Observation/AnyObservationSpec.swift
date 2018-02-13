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
                observation.bind(to: binding)

                expect(binding.receivedBinding) == "hello world"
            }
        }
    }
}

extension AnyObservationSpec {
    class BindingMock : Bindable {
        var receivedBinding: String? = nil

        func advance(element: String?) {
            self.receivedBinding = element
        }
    }
}
