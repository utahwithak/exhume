//
//  FileStream.swift
//  Exeume
//
//  Created by Carl Wieland on 9/16/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Foundation
class FileStream {
    let data: Data
    let stream: InputStream

    var offsetInFile: Int = 0
    let size: Int
    init(forReadingAtPath path: String) throws {

        let url = URL(fileURLWithPath: path)

        let mmapData = try Data(contentsOf: url, options: .alwaysMapped)

        data = mmapData
        size = data.count
        stream = InputStream(data:data)
        stream.open()
    }
    init(forReadingAt url: URL) throws {

        let mmapData = try Data(contentsOf: url, options: .alwaysMapped)

        data = mmapData
        size = data.count
        stream = InputStream(data:data)
        stream.open()
    }

    deinit {
        stream.close()
    }

    func readData(ofLength length: Int) -> Data {
        var data = Data(repeating: 0, count: length)
        let read = data.withUnsafeMutableBytes {
            stream.read($0, maxLength: length)
        }
        if read <= 0 {
            return Data()
        }
        offsetInFile += read
        return data

    }

    func readString(ofLength length: Int) -> String? {
        let data = readData(ofLength: length)

        return String(data: data, encoding: .utf8)
    }

    func readDosString(_ to:inout String, count: Int) -> Int {
        let cp437 = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.dosLatinUS.rawValue))
        return readString(&to, count: count, encoding: String.Encoding(rawValue: cp437))
    }

    func readString(_ to:inout String, count: Int, encoding: String.Encoding) -> Int {
        if count == 0 {
            to = ""
            return 0
        }
        let data = self.readData(ofLength: count)
        if data.count == count {
            if let str = String(bytes: data, encoding: encoding) {
                to = str
                return data.count
            } else {
                return -1
            }

        }
        return -1
    }

    @discardableResult
    func readValue<T>(into val: inout T) -> Bool {
        let rVal = stream.readValue(into: &val)
        offsetInFile += rVal
        return rVal > 0

    }

    public func skip(bytes count: Int) {
        if count == 0 {
            return
        }

        assert(count > 0)
        var data = [UInt8](repeating:0, count: count)
        offsetInFile += stream.read(&data, maxLength: count)

    }

    public var isAtEnd: Bool {
        return offsetInFile == size
    }

    func readBigUInt32() -> UInt32 {
        var unknownVal: UInt32 = 0
        readValue(into: &unknownVal)
        return unknownVal.bigEndian
    }

    func readBigUInt16() -> UInt16 {
        var unknownVal: UInt16 = 0
        readValue(into: &unknownVal)
        return unknownVal.bigEndian
    }

    func readValues<T>(into: inout [T]) {
        let count = into.count
        offsetInFile += into.withUnsafeMutableBufferPointer { ptr in
            ptr.baseAddress!.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<T>.stride * count, { converted in
                stream.read(converted, maxLength: MemoryLayout<T>.stride * count)
            })

        }

    }

    func readValue() -> UInt32 {
        var unknownVal: UInt32 = 0
        readValue(into: &unknownVal)
        return unknownVal
    }

    func readValue() -> UInt16 {
        var unknownVal: UInt16 = 0
        readValue(into: &unknownVal)
        return unknownVal
    }

    func readValue() -> UInt8 {
        var unknownVal: UInt8 = 0
        readValue(into: &unknownVal)
        return unknownVal
    }

    func readValue() -> Int16 {
        var unknownVal: Int16 = 0
        readValue(into: &unknownVal)
        return unknownVal
    }

}
