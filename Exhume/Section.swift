//
//  Section.swift
//  Exhume
//
//  Created by Carl Wieland on 9/26/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Foundation
import SwiftStone


class Section: NSObject {

    public let start: UInt64
    public private(set) var instructions = [Instruction]()

    public private(set) var calls = [Call]()

    init(start: UInt64) {
        self.start = start
    }

    @objc dynamic public var asmLines: String {
        return self.instructions.flatMap({ $0.asmLine}).joined(separator: "\n")
    }

    func load(from converter: Converter) {
        converter.startConverting(at: start) { (instruction) -> Bool in
            guard let instruction = instruction else {
                return false
            }
            instructions.append(instruction)
            return !instruction.isReturn
        }
        print("count:\(instructions.count)")
    }

    func loadCalls() -> [Section] {
        var childSections = [Section]()
        for inst in instructions {
            if inst.isCall {

                if inst.opString.hasPrefix("0x"), let converted = Int(inst.opString.dropFirst(2), radix:16) {
                    let outSection  = Section(start: UInt64(converted))
                    calls.append(Call(from: self, to: outSection))
                    childSections.append(outSection)
                }
            }
        }

        return childSections
    }
}
