import XCTest
import BigInt
@testable import Navcoin

final class BigUIntTests: XCTestCase {
    func testGiven1Byte_WhenSerialized_AndRequiredLength1_ThenLength1() {
        let data = Data([1])
        let value = BigUInt(data).serialized(requiredLength: 1)
        XCTAssertEqual(value.count, 1)
        XCTAssertEqual(value.bytes, [1])
    }

    func testGiven1Byte_WhenSerialized_AndRequiredLength2_ThenLength2() {
        let data = Data([1])
        let value = BigUInt(data).serialized(requiredLength: 2)
        XCTAssertEqual(value.count, 2)
        XCTAssertEqual(value.bytes, [0, 1])
    }

    func testGiven2Bytes_WhenSerialized_AndRequiredLength1_ThenLength2() {
        let data = Data([1, 2])
        let value = BigUInt(data).serialized(requiredLength: 1)
        XCTAssertEqual(value.count, 2)
        XCTAssertEqual(value.bytes, [1, 2])
    }
}
