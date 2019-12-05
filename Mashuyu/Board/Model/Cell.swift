//
//  Cell.swift
//  Mashuyu
//
//  Created by Benjamin Frost on 11/9/18.
//  Copyright © 2018 Benjamin Frost. All rights reserved.
//

import Foundation



class Cell: BoardElement, Hashable {
    
    static func == (lhs: Cell, rhs: Cell) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        self.name.hash(into: &hasher)
    }
    
    var name: String
    var north: HorizontalEdge { didSet { north.south = self }}
    var south: HorizontalEdge { didSet { south.north = self }}
    var east: VerticalEdge { didSet { east.west = self }}
    var west: VerticalEdge { didSet { west.east = self }}
    var isInsideSolution: Bool? = nil
    
    init(
        name: String,
        north: HorizontalEdge,
        south: HorizontalEdge,
        east: VerticalEdge,
        west: VerticalEdge
        ) {
        
        self.name = name
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
        case nil: return " "
        case .some(true): return "░"
        case .some(false): return "▒"
        }
    }
}
