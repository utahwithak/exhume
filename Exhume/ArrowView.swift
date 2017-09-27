
//
//  ArrowView.swift
//  Exhume
//
//  Created by Carl Wieland on 9/27/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Cocoa

class ArrowView: NSView {

    weak var from: SectionView?
    weak var to: SectionView?

    init(from: SectionView, to: SectionView) {

        var boundingBox = from.view.frame
        boundingBox = boundingBox.union(to.view.frame)


        super.init(frame: boundingBox)

        super.wantsLayer = true


        self.from = from
        self.to = to
        refreshPath()

    }
    override var wantsDefaultClipping: Bool {
        return false
    }

    func refreshFrame() {

        frame = superview?.bounds ?? frame
    }

    func refreshPath() {
        defer {
            setNeedsDisplay(self.frame)
        }

        guard let from = from, let to = to else {
            path = nil
            return
        }
        
        refreshFrame()
        let fromPoint = from.outPoint
        let toPoint = to.inPoint
//
//        if toPoint.x > fromPoint.x {
//            fromPoint.x += view.frame.size.width/2;
//            toPoint.x -= view.view.frame.size.width/2;
//        } else{
//            fromPoint.x -= view.view.frame.size.width/2;
//            toPoint.x += view.view.frame.size.width/2;
//
//        }

        let fromX = CGPoint(x: fromPoint.x + 50, y: fromPoint.y);
        let toX = CGPoint(x: toPoint.x - 50, y: toPoint.y);

        path = NSBezierPath()
        path?.move(to: fromPoint)
        
        path?.curve(to: toPoint, controlPoint1: fromX, controlPoint2: toX)

    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    public private(set) var path: NSBezierPath?



}
