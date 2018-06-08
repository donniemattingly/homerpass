//
//  BarcodeFocusArea.swift
//  Homer Pass
//
//  Created by Donnie Mattingly on 1/8/17.
//  Copyright © 2017 Donnie Mattingly. All rights reserved.
//

import Foundation
import UIKit


enum CornerType{
    case topLeft, topRight, bottomLeft, bottomRight
}

class BarcodeFocusArea : UIView {
    override func draw(_ rect: CGRect) {
        
//        let cornerPath = UIBezierPath(rect: rect)
//        cornerPath.lineWidth = 20.0
//        UIColor(netHex: 0xeeeeee).setStroke()
//        cornerPath.stroke()
//        
//        let clearPath = UIBezierPath(rect: rect)
//        clearPath.lineWidth = 20.0
//        UIColor.clear.setStroke()
//        clearPath.stroke()
        
        UIColor(netHex: 0xeeeeee).setStroke()
        let corners = getCorners(ofRect: rect, lineWidth: 20.0)
        for corner in corners{
            for path in corner{
                path.stroke()
            }
        }
    }
    
    @objc func getCorners(ofRect: CGRect, lineWidth: CGFloat) -> [[UIBezierPath]]{
        var corners = [[UIBezierPath]]()
        let length = ofRect.height * 0.35
        var cornerValues = [(point: CGPoint, type: CornerType)]()
        
        cornerValues.append((ofRect.origin, .topLeft))
        cornerValues.append((CGPoint(x: ofRect.origin.x, y: ofRect.maxY), .bottomLeft))
        cornerValues.append((CGPoint(x: ofRect.maxX, y: ofRect.origin.y), .topRight))
        cornerValues.append((CGPoint(x: ofRect.maxX, y: ofRect.maxY), .bottomRight))
    
        for cornerValue in cornerValues {
            corners.append(getCorner(origin: cornerValue.point, length: length, lineWidth: lineWidth, cornerType: cornerValue.type))
        }
        
        return corners
    }
    
    func getCorner(origin: CGPoint, length: CGFloat, lineWidth: CGFloat, cornerType: CornerType) -> [UIBezierPath]{
        var corner = [UIBezierPath]()
        var xChangedPoint: CGPoint
        var yChangedPoint: CGPoint
        
        switch cornerType{
        case .topLeft:
            xChangedPoint = CGPoint(x: origin.x + length, y: origin.y)
            yChangedPoint = CGPoint(x: origin.x, y: origin.y + length)
            break
        case .topRight:
            xChangedPoint = CGPoint(x: origin.x - length, y: origin.y)
            yChangedPoint = CGPoint(x: origin.x, y: origin.y + length)
            break
        case .bottomLeft:
            xChangedPoint = CGPoint(x: origin.x + length, y: origin.y)
            yChangedPoint = CGPoint(x: origin.x, y: origin.y - length)
            break
        case .bottomRight:
            xChangedPoint = CGPoint(x: origin.x - length, y: origin.y)
            yChangedPoint = CGPoint(x: origin.x, y: origin.y - length)
            break
        }
        
        corner.append(getPathFromPoints(point1: origin, point2: xChangedPoint, lineWidth: lineWidth))
        corner.append(getPathFromPoints(point1: origin, point2: yChangedPoint, lineWidth: lineWidth))
        
        return corner
    }
    
    @objc func getPathFromPoints(point1: CGPoint, point2: CGPoint, lineWidth: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.lineWidth = lineWidth
        return path
    }
}
