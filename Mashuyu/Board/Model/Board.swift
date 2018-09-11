//
//  Board.swift
//  Mashuyu
//
//  Created by Benjamin Frost on 11/9/18.
//  Copyright © 2018 Benjamin Frost. All rights reserved.
//

import Foundation


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




