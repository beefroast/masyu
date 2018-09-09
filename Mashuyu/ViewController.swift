//
//  ViewController.swift
//  Mashuyu
//
//  Created by Benjamin Frost on 9/9/18.
//  Copyright © 2018 Benjamin Frost. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        Board.instantiate(width: 1, height: 1)
    }


}






class BoardElement<N, S, E, W> {
    
    var north: N
    var south: S
    var east: E
    var west: W
 
    init(north: N, south: S, east: E, west: W) {
        self.north = north
        self.south = south
        self.east = east
        self.west = west
    }
}

class Cell: BoardElement<HorizontalEdge, HorizontalEdge, VerticalEdge, VerticalEdge> {
    
    static func attachToEdges(north: HorizontalEdge, south: HorizontalEdge, east: VerticalEdge, west: VerticalEdge) {
        
        let cell = Cell(north: north, south: south, east: east, west: west)
        
        north.south = cell
        south.north = cell
        east.west = cell
        west.east = cell
    }
}

class HorizontalEdge: BoardElement<Cell?, Cell?, Corner, Corner> {
    
    convenience init(east: Corner, west: Corner) {
        self.init(north: nil, south: nil, east: east, west: west)
        east.west = self
        west.east = self
    }
}

class VerticalEdge: BoardElement<Corner, Corner, Cell?, Cell?> {
    
    convenience init(north: Corner, south: Corner) {
        self.init(north: north, south: south, east: nil, west: nil)
        north.south = self
        south.north = self
    }
}

class Corner: BoardElement<VerticalEdge?, VerticalEdge?, HorizontalEdge?, HorizontalEdge?> {
    
    convenience init() {
        self.init(north: nil, south: nil, east: nil, west: nil)
    }
}

extension Array {
    
    func mapPairs<T>(_ fn: (Element, Element) -> T) -> [T] {
        var previousElement: Element? = nil
        return self.compactMap { (right) -> T? in
            if let left = previousElement {
                previousElement = right
                return fn(left, right)
            } else {
                previousElement = right
                return nil
            }
        }
    }
    

}

extension Sequence {
    func forPairs(_ fn: (Element, Element) -> Void) -> Void {
        var previousElement: Element? = nil
        for right in self {
            if let left = previousElement {
                fn(left, right)
            }
            previousElement = right
        }
    }
}

class Board {
    
    
    static func instantiate(width: Int, height: Int) -> Board {
        
        // Make the corner bits
        
        let corners = (0...width).map { (i) -> [Corner] in
            return (0...height).map { (i) -> Corner in return Corner.init() }
        }
        
        // Make the vertical edges
        
        (0...width).forPairs { (x0, x1) in
            (0...height).forPairs({ (y0, y1) in
                
                // Build or fetch the edges
                
                let westEdge = VerticalEdge(
                    north: corners[x0][y0],
                    south: corners[x0][y1]
                )
                
                let northEdge = HorizontalEdge(
                    east: corners[x1][y0],
                    west: corners[x0][y0]
                )
                
                let eastEdge = corners[x1][y0].south ?? VerticalEdge(
                    north: corners[x1][y0],
                    south: corners[x1][y1]
                )
                
                let southEdge = corners[x0][y1].east ?? HorizontalEdge(
                    east: corners[x1][y1],
                    west: corners[x0][y1]
                )
                
                // Put a cell in the middle
                
                Cell.attachToEdges(north: northEdge, south: southEdge, east: eastEdge, west: westEdge)
                
                
            })
        }
        
        
        
        
        
        
        return Board()
        
    }
}




//class Cell {
//
//    var north: HorizontalEdge
//    var south: HorizontalEdge
//    var east: VerticalEdge
//    var west: VerticalEdge
//
//    init(
//        north: HorizontalEdge,
//        south: HorizontalEdge,
//        east: VerticalEdge,
//        west: VerticalEdge
//        ) {
//
//        self.north = north
//        self.south = south
//        self.east = east
//        self.west = west
//    }
//}
//
//
//class Edge {
//
//
//}
//
//class VerticalEdge: Edge {
//
//    var north: Corner?
//    var south: Corner?
//    var east: Cell?
//    var west: Cell?
//
//    init(
//        north: Corner?,
//        south: Corner?,
//        east: Cell?,
//        west: Corner
//        ) {
//
//        self.north = north
//        self.south = south
//        self.east = east
//        self.west = west
//    }
//
//}
//
//class HorizontalEdge: Edge {
//
//    var north: HorizontalEdge
//    var south: HorizontalEdge
//    var east: VerticalEdge
//    var west: VerticalEdge
//
//    init(
//        north: HorizontalEdge,
//        south: HorizontalEdge,
//        east: VerticalEdge,
//        west: VerticalEdge
//        ) {
//
//        self.north = north
//        self.south = south
//        self.east = east
//        self.west = west
//    }
//}
//
//class Corner {
//
//    var north: HorizontalEdge
//    var south: HorizontalEdge
//    var east: VerticalEdge
//    var west: VerticalEdge
//
//    init(
//        north: HorizontalEdge,
//        south: HorizontalEdge,
//        east: VerticalEdge,
//        west: VerticalEdge
//        ) {
//
//        self.north = north
//        self.south = south
//        self.east = east
//        self.west = west
//    }
//
//}
