//
//  Call.swift
//  Exhume
//
//  Created by Carl Wieland on 9/26/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Foundation

class Call {
    weak var source: Section?
    weak var destination: Section?

    init(from source: Section, to: Section) {
        self.source = source
        destination = to
    }
}
