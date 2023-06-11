import XCTest
@testable import ParArg

final class ParArgTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(ParArg().text, "Hello, World!")
        
        let firstTest = ParArg.parse(inputs: ["myappname.app", "-d", "--barbecue=apples"])
        XCTAssertEqual(firstTest,
                       [ParArg(name: "-d", value: nil),
                        ParArg(name: "--barbecue", value: "apples")])
        
        XCTAssertNil(firstTest["a"])
        XCTAssertNotNil(firstTest["-d"])
        XCTAssertNil(firstTest.value(for: "-d"))
        XCTAssertNotNil(firstTest["--barbecue"])
        XCTAssertEqual(firstTest["--barbecue"]?.value, "apples")
        
        XCTAssertEqual(ParArg.parse(inputs: ["--barbecue="]), [])
        
        XCTAssertEqual(ParArg.parse(inputs: ["--barbecue=="]),
                       [ParArg(name: "--barbecue", value: "=")])
        
        XCTAssertEqual(ParArg.parse(inputs: ["--barbecue"]),
                       [ParArg(name: "--barbecue", value: nil)])
        
        XCTAssertEqual(ParArg.parse(inputs: ["--barbecue", "apples"]),
                       [ParArg(name: "--barbecue", value: "apples")])
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
