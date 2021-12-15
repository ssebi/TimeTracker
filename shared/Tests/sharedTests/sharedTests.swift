import XCTest
@testable import shared

final class sharedTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(shared().text, "Hello, World!")
    }
}
