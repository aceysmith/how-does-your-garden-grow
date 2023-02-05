//
//  RootSegment.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/3/23.
//

struct RootSegment {
    enum Direction: Int {
        case left = 0
        case right
        case up
        case down
    }
    
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
        if let left = self.left {
            totalSegments += left.grownSubSegments
        }
        if let right = self.right {
            totalSegments += right.grownSubSegments
        }
        if let down = self.down {
            totalSegments += down.grownSubSegments
        }
        return totalSegments
    }
    
    // A segment is a sub-segment of itself
    var subSegments: [RootSegment] {
        var segments = [self]
        if let left = self.left {
            segments += left.subSegments
        }
        if let right = self.right {
            segments += right.subSegments
        }
        if let down = self.down {
            segments += down.subSegments
        }
        return segments
    }
    
    func computeSegmentPositions(plantRelativePosition: PlantRelativePosition) -> [(RootSegment, PlantRelativePosition)] {
        var segmentPositions = [(self, plantRelativePosition)]
        if let left = self.left {
            segmentPositions += left.computeSegmentPositions(
                plantRelativePosition: PlantRelativePosition(x: plantRelativePosition.x - 1, y: plantRelativePosition.y)
            )
        }
        if let right = self.right {
            segmentPositions += right.computeSegmentPositions(
                plantRelativePosition: PlantRelativePosition(x: plantRelativePosition.x + 1, y: plantRelativePosition.y)
            )
        }
        if let down = self.down {
            segmentPositions += down.computeSegmentPositions(
                plantRelativePosition: PlantRelativePosition(x: plantRelativePosition.x, y: plantRelativePosition.y + 1)
            )
        }
        if let up = self.up {
            segmentPositions += up.computeSegmentPositions(
                plantRelativePosition: PlantRelativePosition(x: plantRelativePosition.x, y: plantRelativePosition.y - 1)
            )
        }
        return segmentPositions
    }
}
