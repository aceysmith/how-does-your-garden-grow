import UIKit

var dirtTile = DirtTile(size: CGSize(width: 100, height: 100))

var downOne = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: nil)
var root = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: downOne)
dirtTile.displayRootSegments(rootSegments: [root])
