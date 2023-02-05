//
//  RootSegment.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/3/23.
//

struct RootSegment {    
    var grown = false
    let parentDirection: Direction
    var segments: [RootSegment?]

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
    
    var grownSubSegments: [RootSegment] {
        if !grown {
            return []
        }
        var totalSegments = [self]
        for segment in self.segments {
            guard let segment else { continue }
            totalSegments += segment.grownSubSegments
        }
        return totalSegments
    }
    
    // A segment is a sub-segment of itself
    var subSegments: [RootSegment] {
        var segments = [self]
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
                plantRelativePosition: plantRelativePosition.relativePosition(moving: Direction(rawValue: index)!)
            )
        }
        return segmentPositions
    }
    
    // Grow next segment
    // TODO: This is ugly as hell, refactor now and/or after jam
    mutating func grow(position: PlantRelativePosition, canGrow: (PlantRelativePosition) -> Bool) -> Bool {
        // TODO: only set to true if target tile is unoccupied
        if !grown {
            grown = true
            return true
        } else {
            for (i, segment) in segments.enumerated().shuffled() {
                if var segment {
                    let nextPosition = position.relativePosition(moving: Direction(rawValue: i)!)
//                    if !canGrow(nextPosition) { continue }
                    let didGrow = segment.grow(position: nextPosition, canGrow: canGrow)
                    if didGrow {
                        self.segments[i] = segment
                        return true
                    }
                }
            }
            return false
        }
    }
}
