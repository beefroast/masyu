//
//  ViewController.swift
//  Mashuyu
//
//  Created by Benjamin Frost on 9/9/18.
//  Copyright © 2018 Benjamin Frost. All rights reserved.
//

import UIKit


enum InvalidStateError: Error {
    case cornerError(Corner)
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let board = Board.instantiate(width: 2, height: 2) else { return }
        
        
        
        
    }
    
    
    
//    func update(edge: inout Edge, toState state: EdgeSolutionState) {
//
//        guard edge.state != state else { return }
//
//        edge.state = state
//
//        switch state {
//
//        case .solution:
//            let (e1, e2) = edge.corners
//        case .clear:
//        case .unknown:
//        }
//
//
//
//    }
    
    func ensureCornerStateIsValidForWhiteStone(corner: Corner) throws {
        
        switch corner.numberOfSolutionEdges() {
            
        case 0: return
        case 1: return
        case 2:
            switch (corner.north?.state, corner.south?.state, corner.east?.state, corner.west?.state) {
                case (.some(.solution), .some(.solution), _, _): return
                case (_, _, .some(.solution), .some(.solution)): return
                default:
                    throw InvalidStateError.cornerError(corner)
            }
            
        default:
            throw InvalidStateError.cornerError(corner)
        }
    }
    
    
//    func checkForWhiteStoneOnHorizontal(c: Corner) -> Bool {
//
//        guard c.cornerObstacle == .white else { return false }
//        guard c.north == nil || c.south == nil else { return false }
//        guard let e = c.east, let w = c.west else { return false }
//
//        // E and W are in the solution
//        e.state = .solution
//        w.state = .solution
//
//        return true
//    }
//
//    func checkCornerValid(c: Corner) -> Bool {
//
//
//
//
//    }
    
    
}


protocol Rule {
    associatedtype Element
    func validate(element: Element) throws
}

class WhiteStoneRule: Rule {
    
    typealias Element = Corner
    
    func validate(element: Corner) throws {
        
        let corner = element
        
        switch corner.numberOfSolutionEdges() {
            
        case 0: return
        case 1: return
        case 2:
            switch (corner.north?.state, corner.south?.state, corner.east?.state, corner.west?.state) {
            case (.some(.solution), .some(.solution), _, _): return
            case (_, _, .some(.solution), .some(.solution)): return
            default:
                throw InvalidStateError.cornerError(corner)
            }
            
        default:
            throw InvalidStateError.cornerError(corner)
        }
    }
}

enum OrthogonalDirection {
    case north
    case south
    case east
    case west
}

//protocol CornerObstacle {
//    cornerValid(corner: Corner)
//}

enum CornerObstacle {
    case none
    case white
    case black
}

protocol BoardElement {
    
    associatedtype Vertical
    associatedtype Horizontal
    
    var north: Vertical { get }
    var south: Vertical { get }
    var east: Horizontal { get }
    var west: Horizontal { get }
}

class Cell: BoardElement {
    
    var north: HorizontalEdge { didSet { north.south = self }}
    var south: HorizontalEdge { didSet { south.north = self }}
    var east: VerticalEdge { didSet { east.west = self }}
    var west: VerticalEdge { didSet { west.east = self }}
    
    init(
        north: HorizontalEdge,
        south: HorizontalEdge,
        east: VerticalEdge,
        west: VerticalEdge
        ) {
        self.north = north
        self.south = south
        self.east = east
        self.west = west
    }
    
    func leftMostEdge() -> VerticalEdge { return west.leftMostEdge() }
    func rightMostEdge() -> VerticalEdge { return east.rightMostEdge() }
}

enum EdgeSolutionState {
    case unknown
    case solution
    case clear
}

protocol Edge {
    var state: EdgeSolutionState { get set }
    var corners: (Corner, Corner) { get }
}

class HorizontalEdge: Edge, BoardElement {
    
    weak var north: Cell?
    weak var south: Cell?
    var east: Corner { didSet { east.west = self }}
    var west: Corner { didSet { west.east = self }}
    
    var state: EdgeSolutionState = .unknown
    var corners: (Corner, Corner) { get { return (west, east) }}
    
    init(
        north: Cell?,
        south: Cell?,
        east: Corner,
        west: Corner) {
        
        self.north = north
        self.south = south
        self.east = east
        self.west = west
    }
    
    convenience init(east: Corner, west: Corner) {
        self.init(north: nil, south: nil, east: east, west: west)
    }
}

class VerticalEdge: Edge, BoardElement {
    
    var north: Corner { didSet { north.south = self }}
    var south: Corner { didSet { south.north = self }}
    weak var east: Cell?
    weak var west: Cell?
    
    var state: EdgeSolutionState = .unknown
    var corners: (Corner, Corner) { get { return (north, south) }}

    init(
        north: Corner,
        south: Corner,
        east: Cell?,
        west: Cell?) {
        
        self.north = north
        self.south = south
        self.east = east
        self.west = west
    }
    
    convenience init(north: Corner, south: Corner) {
        self.init(north: north, south: south, east: nil, west: nil)
    }
    
    func leftMostEdge() -> VerticalEdge {
        guard let x = self.west else { return self }
        return x.west.leftMostEdge()
    }
    
    func rightMostEdge() -> VerticalEdge {
        guard let x = self.east else { return self }
        return x.east.rightMostEdge()
    }
}

class Corner: BoardElement {
    
    weak var north: VerticalEdge?
    weak var south: VerticalEdge?
    weak var east: HorizontalEdge?
    weak var west: HorizontalEdge?

    
    var cornerObstacle: CornerObstacle
    
    init(cornerObstacle: CornerObstacle = .none) {
        self.cornerObstacle = cornerObstacle
    }
    
    func numberOfSolutionEdges() -> Int {
        return (north?.state == .solution) ? 1 : 0
            + (south?.state == .solution) ? 1 : 0
            + (east?.state == .solution) ? 1 : 0
            + (west?.state == .solution) ? 1 : 0
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
    
    let width: Int
    let height: Int
    let northWestCell: Cell
    
    init(width: Int, height: Int, northWestCell: Cell) {
        self.width = width
        self.height = height
        self.northWestCell = northWestCell
    }
    
    static func instantiate(width: Int, height: Int) -> Board? {

        // Make the corner bits
        
        let corners = (0...width).map { (x) -> [Corner] in
            return (0...height).map { (y) -> Corner in
                // This is the corner at x, y
                return Corner()
            }
        }
        
        // Make the vertical edges
        
        var topLeftCell: Cell? = nil
        
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
                
                let cell = Cell(
                    north: northEdge,
                    south: southEdge,
                    east: eastEdge,
                    west: westEdge
                )
                
                // Keep a reference to the top right cell
                topLeftCell = topLeftCell ?? cell
            })
        }
        
        return topLeftCell.map({ (c) -> Board in
            Board(width: width, height: height, northWestCell: c)
        })
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
