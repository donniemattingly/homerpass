import XCTest
@testable import Homer_Pass

class Homer_PassTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Homer_Pass().text, "Hello, World!")
    }


    static var allTests : [(String, (Homer_PassTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
