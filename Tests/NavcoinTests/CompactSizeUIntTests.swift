import XCTest
import Foundation
import BinaryExtensions
@testable import Navcoin

final class CompactSizeUIntTests: XCTestCase {
    func testGiven0Bytes_WhenInit_ThenNil() {
        XCTAssertNil(CompactSizeUInt(data: Data()))
    }

    func testGiven1Byte_WithByteInRangeFrom0To0xfc_WhenInit_ThenAssignByteToValue() {
        let size1 = CompactSizeUInt(data: Data([0]))!
        let size2 = CompactSizeUInt(data: Data([0xfc]))!
        XCTAssertEqual(size1.value, 0)
        XCTAssertEqual(size2.value, 0xfc)
    }

    func testGiven3Bytes_WithFirstByte0xfd_WhenInit_ThenAssignLast2ToValue() {
        let size1 = CompactSizeUInt(data: Data([253, 253, 0]))!
        let size2 = CompactSizeUInt(data: Data([253, 255, 255]))!
        XCTAssertEqual(size1.value, UInt(data: Data([253, 0])))
        XCTAssertEqual(size2.value, UInt(data: Data([255, 255])))
    }

    func testGivenLessThan3Bytes_WithFirstByte0xfd_WhenInit_ThenNil() {
        XCTAssertNil(CompactSizeUInt(data: Data([253, 253])))
    }

    func testGiven5Bytes_WithFirstByte0xfe_WhenInit_ThenAssignLast4BytesToValue() {
        let size1 = CompactSizeUInt(data: Data([254, 0, 0, 1, 0]))!
        let size2 = CompactSizeUInt(data: Data([254, 255, 255, 255, 255]))!
        XCTAssertEqual(size1.value, UInt(data: Data([0, 0, 1, 0])))
        XCTAssertEqual(size2.value, UInt(data: Data([255, 255, 255, 255])))
    }

    func testGivenLessThan5Bytes_WithFirstByte0xfe_WhenInit_ThenNil() {
        XCTAssertNil(CompactSizeUInt(data: Data([254, 0, 0, 1])))
    }

    func testGiven9Bytes_Data_WithFirstByte0xff_ThenAssignLast8BytesToValue() {
        let size1 = CompactSizeUInt(data: Data([255, 0, 0, 0, 0, 1, 0, 0, 0]))!
        let size2 = CompactSizeUInt(data: Data([255, 255, 255, 255, 255, 255, 255, 255, 255]))!
        XCTAssertEqual(size1.value, UInt(data: Data([0, 0, 0, 0, 1, 0, 0, 0])))
        XCTAssertEqual(size2.value, UInt(data: Data([255, 255, 255, 255, 255, 255, 255, 255])))
    }

    func testGivenLessThan9Bytes_WithFirstByte0xff_WhenInit_ThenNil() {
        XCTAssertNil(CompactSizeUInt(data: Data([255, 0, 0, 0, 0, 1, 0, 0])))
    }

    func testGivenValue_InRangeFrom0To0xfc_WhenInit_AndGetBytes_ThenAssertEqual() {
        let size1 = CompactSizeUInt(0)
        let size2 = CompactSizeUInt(0xfc)
        XCTAssertEqual(size1.bytes, [0])
        XCTAssertEqual(size2.bytes, [0xfc])
    }

    func testGivenValue_InRangeFrom0xfdTo0xffff_WhenInit_AndGetBytes_ThenAssertEqual() {
        let size1 = CompactSizeUInt(0xfd)
        let size2 = CompactSizeUInt(0xffff)
        XCTAssertEqual(size1.bytes, [253, 253, 0])
        XCTAssertEqual(size2.bytes, [253, 255, 255])
    }

    func testGivenValue_InRangeFrom0x10000To0xffffffff_WhenInit_AndGetBytes_ThenAssertEqual() {
        let size1 = CompactSizeUInt(0x10000)
        let size2 = CompactSizeUInt(0xffffffff)
        XCTAssertEqual(size1.bytes, [254, 0, 0, 1, 0])
        XCTAssertEqual(size2.bytes, [254, 255, 255, 255, 255])
    }

    func testGivenValue_InRangeFrom0x100000000To0xffffffffffffffff_WhenInit_AndGetBytes_ThenAssertEqual() {
        let size1 = CompactSizeUInt(0x100000000)
        let size2 = CompactSizeUInt(UInt(0xffffffffffffffff))
        XCTAssertEqual(size1.bytes, [255, 0, 0, 0, 0, 1, 0, 0, 0])
        XCTAssertEqual(size2.bytes, [255, 255, 255, 255, 255, 255, 255, 255, 255])
    }

    func testGivenValue_InRangeFrom0To0xfc_WhenInit_AndGetTotalByteCount_ThenEqual1() {
        let size1 = CompactSizeUInt(0)
        let size2 = CompactSizeUInt(0xfc)
        XCTAssertEqual(size1.totalByteCount, 1)
        XCTAssertEqual(size2.totalByteCount, 1)
    }

    func testGivenValue_InRangeFrom0xfdTo0xffff_WhenInit_AndGetTotalByteCount_ThenEqual3() {
        let size1 = CompactSizeUInt(0xfd)
        let size2 = CompactSizeUInt(0xffff)
        XCTAssertEqual(size1.totalByteCount, 3)
        XCTAssertEqual(size2.totalByteCount, 3)
    }

    func testGivenValue_InRangeFrom0x10000To0xffffffff_WhenInit_AndGetTotalByteCount_ThenEqual5() {
        let size1 = CompactSizeUInt(0x10000)
        let size2 = CompactSizeUInt(0xffffffff)
        XCTAssertEqual(size1.totalByteCount, 5)
        XCTAssertEqual(size2.totalByteCount, 5)
    }

    func testGivenValue_InRangeFrom0x100000000To0xffffffffffffffff_WhenInit_AndGetTotalByteCount_ThenEqual9() {
        let size1 = CompactSizeUInt(0x100000000)
        let size2 = CompactSizeUInt(UInt(0xffffffffffffffff))
        XCTAssertEqual(size1.totalByteCount, 9)
        XCTAssertEqual(size2.totalByteCount, 9)
    }
}
