//
//  Stream+Additions.swift
//  Exeume
//
//  Created by Carl Wieland on 9/16/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Foundation

extension InputStream {
    @discardableResult
    func readValue<T>(into val: inout T) -> Int {
        return withUnsafeMutablePointer(to: &val) { ptr in
            return ptr.withMemoryRebound(to: UInt8.self, capacity:  MemoryLayout<T>.size) {
                return read($0, maxLength: MemoryLayout<T>.size)
            }
        }
    }

}

