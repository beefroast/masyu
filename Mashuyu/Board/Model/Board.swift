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
    let cells: [[Cell]]
    var northWestCell: Cell {
        get { return cells[0][0] }
    }
    
    init(width: Int, height: Int, cells: [[Cell]]) {
        self.width = width
        self.height = height
        self.cells = cells
    }
    
    static func instantiate(width: Int, height: Int) -> Board {
        
        var objs: [[Any?]] = (0...(2*width)).map { (_) -> [Any?] in
            (0...(2*height)).map { (_) -> Any? in
                return nil
            }
        }
        
        for x in (0...width) {
            for y in (0...height) {
                objs[x*2][y*2] = Corner(name: "(\(x), \(y))")
            }
        }
        
        for x in (0...width-1) {
            for y in (0...height) {
                objs[2*x+1][y*2] = HorizontalEdge(
                    east: objs[2*x+2][y*2] as! Corner,
                    west: objs[2*x][y*2] as! Corner
                )
            }
        }
        
        for x in (0...width) {
            for y in (0...height-1) {
                objs[2*x][y*2+1] = VerticalEdge(
                    north: objs[2*x][y*2] as! Corner,
                    south: objs[2*x][y*2+2] as! Corner
                )
            }
        }
        
        for x in (0...width-1) {
            for y in (0...height-1) {
                objs[2*x+1][y*2+1] = Cell(
                    name: "(\(x), \(y))",
                    north: objs[2*x+1][y*2] as! HorizontalEdge,
                    south: objs[2*x+1][y*2+2] as! HorizontalEdge,
                    east: objs[2*x+2][y*2+1] as! VerticalEdge,
                    west: objs[2*x][y*2+1] as! VerticalEdge
                )
            }
        }
        
        let cells = objs.compactMap { (anyArray) -> [Cell]? in
            let a = anyArray.compactMap { (any) -> Cell? in
                any as? Cell
            }
            if a.count > 0 {
                return a
            } else {
                return nil
            }
        }

        for x in (0...2*width) {
            for y in (0...2*height) {
                if let c = objs[x][y] as? HorizontalEdge {
                    if y == 0 {
                        assert(c.north == nil)
                    } else {
                        assert(c.north != nil)
                    }
                    if y == 2*height {
                        assert(c.south == nil)
                    } else {
                        assert(c.south != nil)
                    }
                }
            }
        }
        
        for x in (0...2*width) {
            for y in (0...2*height) {
                if let c = objs[x][y] as? HorizontalEdge {
                    if x == 0 {
                        assert(c.west == nil)
                    } else {
                        assert(c.west != nil)
                    }
                    if x == 2*width {
                        assert(c.east == nil)
                    } else {
                        assert(c.east != nil)
                    }
                }
            }
        }
        
        for x in (0...2*width) {
            for y in (0...2*height) {
                if let c = objs[x][y] as? Corner {
                    
                    if x == 0 {
                        assert(c.west == nil)
                    } else {
                        assert(c.west != nil)
                    }
                    
                    if x == 2*width {
                        assert(c.east == nil)
                    } else {
                        assert(c.east != nil)
                    }
                    
                    if y == 0 {
                        assert(c.north == nil)
                    } else {
                        assert(c.north != nil)
                    }
                    
                    if y == 2*height {
                        assert(c.south == nil)
                    } else {
                        assert(c.south != nil)
                    }
                    
                }
            }
        }
        
        return Board(width: width, height: height, cells: cells)
    }
    
    
    func clone() -> Board {
        
        let cloned = Board.instantiate(width: self.width, height: self.height)
        
        for x in 0...(width-1) {
            for y in 0...(height-1) {
                let oCell = self.cells[x][y]
                let cCell = cloned.cells[x][y]
                cCell.isInsideSolution = oCell.isInsideSolution
                cCell.north.isInSolution = oCell.north.isInSolution
                cCell.south.isInSolution = oCell.south.isInSolution
                cCell.east.isInSolution = oCell.east.isInSolution
                cCell.west.isInSolution = oCell.west.isInSolution
                cCell.north.west.cornerState = oCell.north.west.cornerState
                cCell.north.east.cornerState = oCell.north.east.cornerState
                cCell.south.west.cornerState = oCell.south.west.cornerState
                cCell.south.east.cornerState = oCell.south.east.cornerState
            }
        }
        
        return cloned
    }
    
    
    func stringRepresentation() -> String {
        
        var corner: Corner? = northWestCell.west.north
        var edge: VerticalEdge? = nil
        var lineStrings: [String] = []
        
        while corner != nil || edge != nil {
            if let c = corner {
                lineStrings.append(c.stringRepresentationRecursive())
                edge = c.south
                corner = nil
            } else if let e = edge {
                lineStrings.append(e.stringRepresentationRecursive())
                corner = e.south
                edge = nil
            }
        }
        
        return lineStrings.joined(separator: "\n")

    }
    
    
}




