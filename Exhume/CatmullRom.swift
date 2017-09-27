//
//  CatmullRom.swift
//  Exhume
//
//  Created by Carl Wieland on 9/27/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Foundation
import Cocoa

extension NSBezierPath {

    convenience init?(catmullRomPoints: [CGPoint], closed: Bool, alpha: CGFloat) {
        self.init()

        if catmullRomPoints.count < 4 {
            return nil
        }

        let startIndex = closed ? 0 : 1
        let endIndex = closed ? catmullRomPoints.count : catmullRomPoints.count - 2

        for i in startIndex..<endIndex {
            let p0 = catmullRomPoints[i-1 < 0 ? catmullRomPoints.count - 1 : i - 1]
            let p1 = catmullRomPoints[i]
            let p2 = catmullRomPoints[(i+1)%catmullRomPoints.count]
            let p3 = catmullRomPoints[(i+1)%catmullRomPoints.count + 1]

            let d1 = (p1 - p0).length
            let d2 = (p2 - p1).length
            let d3 = (p3 - p2).length

            var b1 = p2 * pow(d1, 2 * alpha)
            b1 = b1 - (p0 * pow(d2, 2 * alpha))
            b1 = b1 + (p1 * (2 * pow(d1, 2 * alpha) + 3 * pow(d1, alpha) * pow(d2, alpha) + pow(d2, 2 * alpha)))
            b1 = b1 * (1.0 / (3 * pow(d1, alpha) * (pow(d1, alpha) + pow(d2, alpha))))

            var b2 = p1 * pow(d3, 2 * alpha)
            b2 = b2 - (p3 * pow(d2, 2 * alpha))
            b2 = b2 + (p2 * (2 * pow(d3, 2 * alpha) + 3 * pow(d3, alpha) * pow(d2, alpha) + pow(d2, 2 * alpha)))
            b2 = b2 * (1.0 / (3 * pow(d3, alpha) * (pow(d3, alpha) + pow(d2, alpha))))

            if i == startIndex {
                move(to: p1)
            }


            curve(to: p2, controlPoint1: b1, controlPoint2: b2)

        }

        if closed {
            close()
        }
    }
}
