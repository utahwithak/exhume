//
//  Header.swift
//  Exhume
//
//  Created by Carl Wieland on 9/22/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Foundation
struct Header {

    init?(from stream: FileStream) {
        signature = stream.readValue()

        if signature != 0x5a4d /*MZ*/ {
            return nil
        }

        extraBytes = stream.readValue()
        pages = stream.readValue()
        relocations = stream.readValue()
        headerSize = stream.readValue()
        minMemory = stream.readValue()
        maxMemory = stream.readValue()
        ss = stream.readValue()
        sp = stream.readValue()
        checksum = stream.readValue()
        ip = stream.readValue()
        cs = stream.readValue()
        relocTable = stream.readValue()
        overlay = stream.readValue()

    }

    /// This is the "magic number" of an EXE file. The first byte of the file is 0x4d and the second is 0x5a.
    let signature: UInt16 /* == 0x5a4D */

    /// The number of bytes in the last block of the program that are actually used. If this value is zero, that means the entire last block is used (i.e. the effective value is 512).
    let extraBytes: UInt16


    /// Number of blocks in the file that are part of the EXE file. If [02-03] is non-zero, only that much of the last block is used.
    let pages: UInt16

    /// Number of relocation entries stored after the header. May be zero.
    let relocations: UInt16


    /// Number of paragraphs in the header. The program's data begins just after the header, and this field can be used to calculate the appropriate file offset. The header includes the relocation entries. Note that some OSs and/or programs may fail if the header is not a multiple of 512 bytes.
    let headerSize: UInt16

    /// Number of paragraphs of additional memory that the program will need. This is the equivalent of the BSS size in a Unix program. The program can't be loaded if there isn't at least this much memory available to it.
    let minMemory: UInt16

    /// Maximum number of paragraphs of additional memory. Normally, the OS reserves all the remaining conventional memory for your program, but you can limit it with this field.
    let maxMemory: UInt16

    /// Relative value of the stack segment. This value is added to the segment the program was loaded at, and the result is used to initialize the SS register.
    let ss: UInt16

    /// Initial value of the SP register.
    let sp: UInt16

    /// Word checksum. If set properly, the 16-bit sum of all words in the file should be zero. Usually, this isn't filled in.
    let checksum: UInt16

    /// Initial value of the IP register.
    let ip: UInt16

    /// Initial value of the CS register, relative to the segment the program was loaded at.
    let cs: UInt16

    /// Offset of the first relocation item in the file.
    let relocTable: UInt16

    /// Overlay number. Normally zero, meaning that it's the main program.
    let overlay: UInt16

    var entryPoint: UInt64 {
        return UInt64((headerSize + cs) << 4) + UInt64(ip)
    }
}
