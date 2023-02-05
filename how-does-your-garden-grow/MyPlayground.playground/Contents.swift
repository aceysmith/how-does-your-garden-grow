import UIKit

var greeting = "Hello, playground"

var garden = Garden(horizonalTileCount: 3, verticalTileCount: 10)
 
var downThree = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: nil)
var downTwo = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: downThree)
var rightOne = RootSegment(parentDirection: .left, left: nil, right: nil, up: nil, down: nil)
var leftOne = RootSegment(parentDirection: .right, left: nil, right: nil, up: nil, down: nil)
var downOne = RootSegment(parentDirection: .up, left: leftOne, right: rightOne, up: nil, down: downTwo)
var root = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: downOne)
var plant = Plant(root: root, award: 0, tint: .green)
garden.addPlant(position: 1, plant: plant)

//let downThree = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: nil)
//let downTwo = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: downThree)
rightOne = RootSegment(parentDirection: .left, left: nil, right: nil, up: nil, down: nil)
leftOne = RootSegment(parentDirection: .right, left: nil, right: nil, up: nil, down: nil)
downOne = RootSegment(parentDirection: .up, left: leftOne, right: rightOne, up: nil, down: nil)
root = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: downOne)
plant = Plant(root: root, award: 0, tint: .green)
garden.addPlant(position: 2, plant: plant)

garden.grow()
garden.grow()

for (i, plant) in garden.plantPlots.enumerated() {
    if let plant {
        print("plant \(i) segments count: \(plant.rootSegments.count)")
        print("plant \(i) grown segments count: \(plant.grownRootSegments.count)")
        print("plant \(i) grown segments: \(plant.grownRootSegments)")
    }
}
