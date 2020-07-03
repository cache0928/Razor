import XCTest
@testable import Razor

final class RazorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Razor().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
