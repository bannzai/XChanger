import XCTest
@testable import XChanger

final class XChangerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(XChanger().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
