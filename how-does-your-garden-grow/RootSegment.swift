//
//  RootSegment.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/3/23.
//

import Foundation

struct RootSegment {    
    var grown = false
    let parentDirection: Direction
    var segments: [RootSegment?]
    var hue: CGFloat = 0

    var left: RootSegment? {
        segments[Direction.left.rawValue]
    }
    var right: RootSegment? {
        segments[Direction.right.rawValue]
    }
    var up: RootSegment? {
        segments[Direction.up.rawValue]
    }
    var down: RootSegment? {
        segments[Direction.down.rawValue]
    }
    
    init(parentDirection: Direction, left: RootSegment?, right: RootSegment?, up: RootSegment?, down: RootSegment?) {
        self.parentDirection = parentDirection
        self.segments = [left, right, up, down]
    }
    
    mutating func addHue(hue: CGFloat) {
        self.hue = hue
        let segments = self.segments
        var left = self.left
        left?.addHue(hue: hue)
        var right = self.right
        right?.addHue(hue: hue)
        var up = self.up
        up?.addHue(hue: hue)
        var down = self.down
        down?.addHue(hue: hue)
        self.segments = [
            left,
            right,
            up,
            down
        ]
    }
    
    var grownSubSegments: Int {
        if !grown {
            return 0
        }
        var totalSegments = 1
        for segment in self.segments {
            guard let segment else { continue }
            totalSegments += segment.grownSubSegments
        }
        return totalSegments
    }
    
    // A segment is a sub-segment of itself
    var subSegments: Int {
        var segments = 1
        for segment in self.segments {
            guard let segment else { continue }
            segments += segment.subSegments
        }
        return segments
    }
    
    
    func computeSegmentPositions(plantRelativePosition: PlantRelativePosition) -> [(RootSegment, PlantRelativePosition)] {
        var segmentPositions = [(self, plantRelativePosition)]
        for (index, segment) in self.segments.enumerated() {
            guard let segment else { continue }
            segmentPositions += segment.computeSegmentPositions(
                plantRelativePosition: plantRelativePosition.moved(Direction(rawValue: index)!)
            )
        }
        return segmentPositions
    }
    
    mutating func grow(position: PlantRelativePosition, canGrow: (PlantRelativePosition) -> Bool) -> Bool {
        if !grown {
            if canGrow(position) {
                grown = true
                return true
            } else {
                return false
            }
        } else {
            for (i, segment) in segments.enumerated().shuffled() {
                guard var segment else { continue }

                let nextPosition = position.moved(Direction(rawValue: i)!)
                let didGrow = segment.grow(position: nextPosition, canGrow: canGrow)
                if didGrow {
                    self.segments[i] = segment
                    return true
                }
            }
            return false
        }
    }
}
