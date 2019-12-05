//
//  Edge.swift
//  Mashuyu
//
//  Created by Benjamin Frost on 11/9/18.
//  Copyright © 2018 Benjamin Frost. All rights reserved.
//

import Foundation


protocol Edge: AnyObject {
    var isInSolution: Bool? { get set }
    var corners: (Corner, Corner) { get }
    var cells: (Cell?, Cell?) { get }
    func opposite(toCorner: Corner) -> Corner?
    func stringRepresentationRecursive() -> String
}

class HorizontalEdge: Edge, BoardElement {
    
    weak var north: Cell?
    weak var south: Cell?
    var east: Corner { didSet { east.west = self }}
    var west: Corner { didSet { west.east = self }}
    
    var isInSolution: Bool? = nil
    var corners: (Corner, Corner) { get { return (west, east) }}
    var cells: (Cell?, Cell?) { get { return (north, south) }}
    
    init(
        north: Cell?,
        south: Cell?,
        east: Corner,
        west: Corner) {
        
        self.north = north
        self.south = south
        self.east = east
        self.west = west
        
        self.north?.south = self
        self.south?.north = self
        self.east.west = self
        self.west.east = self
    }
    
    convenience init(east: Corner, west: Corner) {
        self.init(north: nil, south: nil, east: east, west: west)
    }
    
    func opposite(toCorner corner: Corner) -> Corner? {
        if east === corner {
            return self.west
        } else if west === corner {
            return self.west
        } else {
            return nil
        }
    }
    
    func stringRepresentationRecursive() -> String {
        return self.stringRepresentation() + self.east.stringRepresentationRecursive() ?? ""
    }
    
    func stringRepresentation() -> String {
        switch self.isInSolution {
        case nil: return "-"
        case .some(true): return "="
        case .some(false): return " "
        }
    }
    
    var debugDescription: String {
        get { return "Edge between [\(self.west.debugDescription)] -> [\(self.east.debugDescription)]" }
    }
}

class VerticalEdge: Edge, BoardElement {

    var north: Corner { didSet { north.south = self }}
    var south: Corner { didSet { south.north = self }}
    weak var east: Cell?
    weak var west: Cell?
    
    var isInSolution: Bool? = nil
    var corners: (Corner, Corner) { get { return (north, south) }}
    var cells: (Cell?, Cell?) { get { return (east, west) }}
    
    init(
        north: Corner,
        south: Corner,
        east: Cell?,
        west: Cell?) {
        
        self.north = north
        self.south = south
        self.east = east
        self.west = west
        
        self.north.south = self
        self.south.north = self
        self.east?.west = self
        self.west?.east = self
    }
    
    convenience init(north: Corner, south: Corner) {
        self.init(north: north, south: south, east: nil, west: nil)
    }

    
    func opposite(toCorner corner: Corner) -> Corner? {
        if north === corner {
            return self.north
        } else if south === corner {
            return self.south
        } else {
            return nil
        }
    }
    
    func stringRepresentationRecursive() -> String {
        return self.stringRepresentation() + (self.east?.stringRepresentationRecursive() ?? "")
    }
    
    func stringRepresentation() -> String {
        switch self.isInSolution {
        case nil: return ":"
        case .some(true): return "|"
        case .some(false): return " "
        }
    }
    
    var debugDescription: String {
        get { return "Edge between [\(self.north.debugDescription)] v [\(self.south.debugDescription)]" }
    }
}
