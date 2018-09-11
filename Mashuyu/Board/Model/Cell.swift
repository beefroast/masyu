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
}
