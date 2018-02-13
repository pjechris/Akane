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
import Akane
@testable import AkaneBond

class AsyncCommandSpec : QuickSpec {
    override func spec() {
        var command: AsyncCommand<Void>!

        describe("execute") {
            context("command is running") {
                beforeEach {
                    command = AsyncCommand() { _, _ in }
                }

                it("sets isExecuting to true") {
                    command.execute(nil)
                    expect(command.isExecuting.value) == true
                }
            }
            context("command is completed") {
                beforeEach {
                    command = AsyncCommand() { _, completed in
                        completed()
                    }
                }

                it("sets isExecuting to false") {
                    command.execute(nil)
                    expect(command.isExecuting.value) == false
                }
            }
        }
    }
}
