//
//  Document.swift
//  Exhume
//
//  Created by Carl Wieland on 9/22/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Cocoa
import SwiftStone

class Document: NSDocument {

    private var stream: FileStream!

    public private(set) var sections = [UInt64: Section]()

    @objc dynamic var rawAsm: String = ""

    var rootSection: Section!

    private override init() {
        super.init()
    }


    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        windowController.window?.contentViewController?.representedObject = self
        self.addWindowController(windowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        return self.stream.data
    }

    override func read(from url: URL, ofType typeName: String) throws {
        stream = try FileStream(forReadingAt: url)
        guard let exe = Header(from: stream) else {
            throw NSError(domain: "com.datumapps.exeume", code: -1, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Invalid EXE File", comment: "Error when attempting to open an exe that doesn't work")])
        }
        
        Swift.print("exe:\(exe)")
        Swift.print("entry point:\(exe.entryPoint)")

        let engine = try SwiftStone(arch: .x86, mode: .x86_16Bit)
        engine.detail = true
        engine.syntax = .intel

        let converter = engine.converter(for: stream.data)

        rootSection = Section(start: exe.entryPoint)
        sections[exe.entryPoint] = rootSection

        var sectionsToLoad = Set<UInt64>()
        sectionsToLoad.insert(exe.entryPoint)
        while let any = sectionsToLoad.popFirst(), let section = sections[any] {
            section.load(from: converter)

            let children = section.loadCalls()
            for child in children {
                if sections[child.start] == nil {
                    sections[child.start] = child
                    sectionsToLoad.insert(child.start)
                }
            }
        }



        rawAsm = rootSection.instructions.map({ $0.asmLine }).joined(separator:"\n")

    }


}

