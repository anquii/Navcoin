import Foundation

struct CompactSizeUInt {
    let value: UInt

    init(_ value: UInt) {
        self.value = value
    }

    init(_ value: Int) {
        guard value >= 0 else {
            preconditionFailure()
        }
        self.value = UInt(value)
    }

    init?(data: Data) {
        guard !data.isEmpty, let firstByte = data.first else {
            return nil
        }
        if firstByte <= 0xfc {
            value = UInt(firstByte)
            return
        }
        let startIndex = data.startIndex + 1
        var endIndex = startIndex
        switch firstByte {
        case 0xfd:
            endIndex += 2
        case 0xfe:
            endIndex += 4
        case 0xff:
            endIndex += 8
        default:
            preconditionFailure()
        }
        guard
            data.indices.contains(startIndex),
            data.indices.contains(endIndex - 1),
            let unsignedInteger = UInt(data: data[startIndex..<endIndex])
        else {
            return nil
        }
        value = unsignedInteger
    }

    var bytes: [UInt8] {
        switch value {
        case 0...0xfc:
            return UInt8(value).bytes
        case 0xfd...0xffff:
            return [UInt8(0xfd)] + UInt16(value).bytes
        case 0x10000...0xffffffff:
            return [UInt8(0xfe)] + UInt32(value).bytes
        case 0x100000000...0xffffffffffffffff:
            return [UInt8(0xff)] + UInt64(value).bytes
        default:
            preconditionFailure()
        }
    }

    var totalByteCount: Int {
        switch value {
        case 0...0xfc:
            return 1
        case 0xfd...0xffff:
            return 3
        case 0x10000...0xffffffff:
            return 5
        case 0x100000000...0xffffffffffffffff:
            return 9
        default:
            preconditionFailure()
        }
    }
}
