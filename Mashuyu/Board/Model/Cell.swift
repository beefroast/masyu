//
//  Cell.swift
//  Mashuyu
//
//  Created by Benjamin Frost on 11/9/18.
//  Copyright © 2018 Benjamin Frost. All rights reserved.
//

import Foundation



class Cell: BoardElement {
    
    var north: HorizontalEdge { didSet { north.south = self }}
    var south: HorizontalEdge { didSet { south.north = self }}
    var east: VerticalEdge { didSet { east.west = self }}
    var west: VerticalEdge { didSet { west.east = self }}
    var isInsideSolution: Bool? = nil
    
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
        
        north.south = self
        south.north = self
        east.west = self
        west.east = self
    }
    
    func stringRepresentationRecursive() -> String {
        return self.stringRepresentation() + self.east.stringRepresentationRecursive()
    }
    
    func stringRepresentation() -> String {
        switch self.isInsideSolution {
        case nil: return "?"
        case .some(true): return "░"
        case .some(false): return "▒"
        }
    }
}
