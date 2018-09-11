//
//  Edge.swift
//  Mashuyu
//
//  Created by Benjamin Frost on 11/9/18.
//  Copyright © 2018 Benjamin Frost. All rights reserved.
//

import Foundation


enum EdgeSolutionState {
    case unknown
    case solution
    case clear
}



protocol Edge: AnyObject {
    var state: EdgeSolutionState { get set }
    var corners: (Corner, Corner) { get }
    func opposite(toCorner: Corner) -> Corner?
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
    
    func opposite(toCorner corner: Corner) -> Corner? {
        if east === corner {
            return self.west
        } else if west === corner {
            return self.west
        } else {
            return nil
        }
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
    
    func opposite(toCorner corner: Corner) -> Corner? {
        if north === corner {
            return self.north
        } else if south === corner {
            return self.south
        } else {
            return nil
        }
    }
}
