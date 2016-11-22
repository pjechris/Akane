//
// This file is part of Akane
//
// Created by JC on 08/07/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Nimble
import Quick
@testable import Akane

class AsyncCommandSpec : QuickSpec {
    override func spec() {
        var command: AsyncCommand<Void>!

        describe("execute") {

            it("changes isExecuting to true") {
                command = AsyncCommand() { _, _ in }

                command.execute(nil)
                expect(command.isExecuting.value) == true
            }

            it("changes back isExecuting to false") {
                command = AsyncCommand() { _, completed in
                    completed()
                }

                command.execute(nil)
                expect(command.isExecuting.value) == false
            }
        }
    }
}