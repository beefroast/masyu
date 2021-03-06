//
//  Solver.swift
//  Mashuyu
//
//  Created by Benjamin Frost on 1/12/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation


enum SolverInconsistencyError: Error {
    case inconsistent
}

class Solver {
    
    func solve(board: Board) throws -> Board {
        let clone = board.clone()
        return try _solve(board: clone)
    }
    
    func _solve(board: Board) throws -> Board {
        
        // First, eliminate all improbable states
        try eliminateImpossibilities(board: board)
        
        if isOneConnectedBody(board: board) {
            // We're done
            return board
        }
        
        // Do a search for the correct solution
        for x in (0...board.width-1) {
            for y in (0...board.height-1) {
                if board.cells[x][y].isInsideSolution == nil {
                    let cloned = board.clone()
                    do {
                        try update(cell: cloned.cells[x][y], isInSolution: true)
                        return try solve(board: cloned)
                    } catch (_) {
                        print("Bad guess")
                        continue
                    }
                }
            }
        }
        
        // None of our solutions are good
        throw SolverInconsistencyError.inconsistent
    }
    
    func eliminateImpossibilities(board: Board) throws {
        
        var lastState: String = board.stringRepresentation()
        
        while true {
            
            // TODO: This could be a bit more efficient, we're retouching corners
            try board.cells.forEach { (row) in
                try row.forEach { (cell) in
                    try self.touchCorner(corner: cell.north.west)
                    try self.touchCorner(corner: cell.north.east)
                    try self.touchCorner(corner: cell.south.west)
                    try self.touchCorner(corner: cell.south.east)
                }
            }
            
            let currentState = board.stringRepresentation()
            
            print(currentState + "\n\n")
            
            if currentState == lastState {
                break
            } else {
                lastState = currentState
            }
        }

    }
    
    func isOneConnectedBody(board: Board) -> Bool {
        
        let allInsideCells = Set(board.cells.flatMap { (cellArray) -> [Cell] in
            cellArray.filter({ $0.isInsideSolution == true })
        })
        
        var visitedCells: Set<Cell> = Set()
        self.visit(cell: allInsideCells.first, visitedCells: &visitedCells)

        return visitedCells.count == allInsideCells.count
    }
    
    func visit(cell: Cell?, visitedCells: inout Set<Cell>) {
        
        guard let c = cell, visitedCells.contains(c) == false else { return }

        visitedCells.insert(c)
        
        if c.north.north?.isInsideSolution == true {
            visit(cell: c.north.north, visitedCells: &visitedCells)
        }
        if c.south.south?.isInsideSolution == true {
            visit(cell: c.south.south, visitedCells: &visitedCells)
        }
        if c.east.east?.isInsideSolution == true {
            visit(cell: c.east.east, visitedCells: &visitedCells)
        }
        if c.west.west?.isInsideSolution == true {
            visit(cell: c.west.west, visitedCells: &visitedCells)
        }
    }
    
    func update(edge: Edge?, toIsInSolution: Bool, throwOnNotExist: Bool = false) throws {
        guard let e = edge else {
            if throwOnNotExist {
                throw SolverInconsistencyError.inconsistent
            }
            return
        }
        try update(edge: e, toIsInSolution: toIsInSolution)
    }
    
    func update(edge: Edge, toIsInSolution: Bool) throws {
                
        // Already set the value of this cell, so we can't update it.
        if let value = edge.isInSolution {
            guard value == toIsInSolution else {
                throw SolverInconsistencyError.inconsistent
            }
            return
        }
        
        edge.isInSolution = toIsInSolution
        
        // Update the cells on either side of the wall
        let cells = edge.cells
        try updateEdgeCell(edgeIsIn: toIsInSolution, mc0: cells.0, mc1: cells.1)
        
        // Let the corners validate themselves and update
        let (c0, c1) = edge.corners
        try touchCorner(corner: c0)
        try touchCorner(corner: c1)
        
    }
    
    func touchCorner(corner: Corner) throws {
        
        let edges: [Edge] = [corner.north, corner.south, corner.east, corner.west].compactMap({ $0 as? Edge })

        
        if corner.cornerState == .whiteStone {
        
            // Make sure that lines run through white stones...
            for edge in edges {
                if let inSolution = edge.isInSolution {
                    try update(edge: corner.oppositeEdge(to: edge), toIsInSolution: inSolution)
                    try corner.edgesParallel(to: edge).forEach { (edge) in
                        try update(edge: edge, toIsInSolution: !inSolution)
                    }
                }
            }
            
            // Make sure edge pieces are lined
            if corner.west == nil {
                try update(edge: corner.north, toIsInSolution: true, throwOnNotExist: true)
                try update(edge: corner.south, toIsInSolution: true, throwOnNotExist: true)
                try update(edge: corner.east, toIsInSolution: false, throwOnNotExist: true)
            }
            
            if corner.east == nil {
                try update(edge: corner.north, toIsInSolution: true, throwOnNotExist: true)
                try update(edge: corner.south, toIsInSolution: true, throwOnNotExist: true)
                try update(edge: corner.west, toIsInSolution: false, throwOnNotExist: true)
            }
            
            if corner.north == nil {
                try update(edge: corner.east, toIsInSolution: true, throwOnNotExist: true)
                try update(edge: corner.west, toIsInSolution: true, throwOnNotExist: true)
                try update(edge: corner.south, toIsInSolution: false, throwOnNotExist: true)
            }
            
            if corner.south == nil {
                try update(edge: corner.east, toIsInSolution: true, throwOnNotExist: true)
                try update(edge: corner.west, toIsInSolution: true, throwOnNotExist: true)
                try update(edge: corner.north, toIsInSolution: false, throwOnNotExist: true)
            }
            
            // Make sure we have a bend
            
            if corner.north?.north.north?.isInSolution == true
                && corner.south?.isInSolution == true {
                try update(edge: corner.south?.south.south, toIsInSolution: false)
            }
            
            if corner.south?.south.south?.isInSolution == true
                && corner.north?.isInSolution == true {
                try update(edge: corner.north?.north.north, toIsInSolution: false)
            }
            
            if corner.east?.east.east?.isInSolution == true
                && corner.west?.isInSolution == true {
                try update(edge: corner.west?.west.west, toIsInSolution: false)
            }
            
            if corner.west?.west.west?.isInSolution == true
                && corner.east?.isInSolution == true {
                try update(edge: corner.east?.east.east, toIsInSolution: false)
            }
            
        }
        
        // Make sure that we're obeying black stone rules
        if corner.cornerState == .blackStone {
            
            // Must be at least two segments long from a black stone...
            
            if corner.north?.isInSolution == true {
                try update(edge: corner.north?.north.north, toIsInSolution: true, throwOnNotExist: true)
            }
            if corner.south?.isInSolution == true {
                try update(edge: corner.south?.south.south, toIsInSolution: true, throwOnNotExist: true)
            }
            if corner.east?.isInSolution == true {
                try update(edge: corner.east?.east.east, toIsInSolution: true, throwOnNotExist: true)
            }
            if corner.west?.isInSolution == true {
                try update(edge: corner.west?.west.west, toIsInSolution: true, throwOnNotExist: true)
            }
            
            // Can exclude a side based approach
            if corner.north?.north.north == nil
                || corner.north?.north.north?.isInSolution == false
                || corner.north?.north.east?.isInSolution == true
                || corner.north?.north.west?.isInSolution == true {
                try update(edge: corner.north, toIsInSolution: false)
                try update(edge: corner.south, toIsInSolution: true)
                try update(edge: corner.south?.south.south, toIsInSolution: true)
            }
            if corner.south?.south.south == nil
                || corner.south?.south.south?.isInSolution == false
                || corner.south?.south.east?.isInSolution == true
                || corner.south?.south.west?.isInSolution == true {
                try update(edge: corner.south, toIsInSolution: false)
                try update(edge: corner.north, toIsInSolution: true)
                try update(edge: corner.north?.north.north, toIsInSolution: true)
            }
            if corner.east?.east.east == nil
                || corner.east?.east.east?.isInSolution == false
                || corner.east?.east.north?.isInSolution == true
                || corner.east?.east.south?.isInSolution == true {
                try update(edge: corner.east, toIsInSolution: false)
                try update(edge: corner.west, toIsInSolution: true)
                try update(edge: corner.west?.west.west, toIsInSolution: true)
            }
            if corner.west?.west.west == nil
                || corner.west?.west.west?.isInSolution == false
                || corner.west?.west.north?.isInSolution == true
                || corner.west?.west.south?.isInSolution == true {
                try update(edge: corner.west, toIsInSolution: false)
                try update(edge: corner.east, toIsInSolution: true)
                try update(edge: corner.east?.east.east, toIsInSolution: true)
            }
            
            
        }
        
        let inSolutionEdges = edges.filter({ $0.isInSolution == true })
        let outSolutionEdges = edges.filter({ $0.isInSolution == false })
        let undecidedSolutionEdges = edges.filter({ $0.isInSolution == nil })

        // Can't have more than two edges on a corner
        if inSolutionEdges.count > 2 {
            throw SolverInconsistencyError.inconsistent
        }
        
        // If we've got two edges on the corner, none of the other edges are in
        if inSolutionEdges.count == 2 {
            for edge in undecidedSolutionEdges {
                try update(edge: edge, toIsInSolution: false)
            }
        }
        
        // If we've got an in, and there's only one remaining spot left, that's it
        if inSolutionEdges.count == 1 && undecidedSolutionEdges.count == 1 {
            try update(edge: undecidedSolutionEdges[0], toIsInSolution: true)
        }
        
        
        
    }
    
    func updateEdgeCell(edgeIsIn: Bool, mc0: Cell?, mc1: Cell?) throws {
        
        switch (mc0, mc1) {
            
        case (.some(let cell), nil): fallthrough
        case (nil, .some(let cell)):
            try updateEdgeCell(edgeIsIn: edgeIsIn, cell: cell)
            
        case (.some(let c0), .some(let c1)):
            try updateEdgeCell(edgeIsIn: edgeIsIn, c0: c0, c1: c1)
            
        default:
            return
            
        }
    }
    
    func updateEdgeCell(edgeIsIn: Bool, cell: Cell) throws {
        try update(cell: cell, isInSolution: edgeIsIn)
    }
    
    func updateEdgeCell(edgeIsIn: Bool, c0: Cell, c1: Cell) throws {
        
        switch (c0.isInsideSolution, c1.isInsideSolution) {
            
        case (.some(let c0In), .some(let c1In)):
            guard !((c0In != edgeIsIn) != c1In) else {
                throw SolverInconsistencyError.inconsistent
            }
        
        case (.some(let c0In), nil):
            try update(cell: c1, isInSolution: c0In != edgeIsIn)
            
        case (nil, .some(let c1In)):
            try update(cell: c0, isInSolution: c1In != edgeIsIn)
            
        default:
            return
            
        }

    }
    
    
    func updateEdgeCell(originalCellIsInSolution: Bool, edge: Edge, adjacentCell: Cell) throws {
        
        switch (edge.isInSolution, adjacentCell.isInsideSolution) {
            
        case (.some(let edgeIsIn), nil):
            try update(cell: adjacentCell, isInSolution: originalCellIsInSolution != edgeIsIn)
            
        case (nil, .some(let adjacentCellIsIn)):
            try update(edge: edge, toIsInSolution: originalCellIsInSolution != adjacentCellIsIn)
            
        default: return
            
        }
        
    }
    
    
    
    func updateEdgeCell(originalCellIsInSolution: Bool, edge: Edge, adjacentCell: Cell?) throws {
        if let c = adjacentCell {
            try updateEdgeCell(originalCellIsInSolution: originalCellIsInSolution, edge: edge, adjacentCell: c)
        } else {
            try update(edge: edge, toIsInSolution: originalCellIsInSolution)
        }
    }

    func update(cell: Cell?, isInSolution: Bool) throws {
        guard let c = cell else { return }
        try update(cell: c, isInSolution: isInSolution)
    }
    
    func update(cell: Cell, isInSolution: Bool) throws {
                
        // Already set the value of this cell, so we can't update it.
        if let value = cell.isInsideSolution {
            guard value == isInSolution else {
                throw SolverInconsistencyError.inconsistent
            }
            return
        }
        
        cell.isInsideSolution = isInSolution
        
        // Update the cells/edges based on cell/edge being in or out...
        try updateEdgeCell(originalCellIsInSolution: isInSolution, edge: cell.north, adjacentCell: cell.north.north)
        try updateEdgeCell(originalCellIsInSolution: isInSolution, edge: cell.south, adjacentCell: cell.south.south)
        try updateEdgeCell(originalCellIsInSolution: isInSolution, edge: cell.east, adjacentCell: cell.east.east)
        try updateEdgeCell(originalCellIsInSolution: isInSolution, edge: cell.west, adjacentCell: cell.west.west)
        
        // Update across the corner of white stones...
        if cell.north.west.cornerState == .whiteStone {
            try update(cell: cell.north.west.north?.west, isInSolution: !isInSolution)
        }
        if cell.north.east.cornerState == .whiteStone {
            try update(cell: cell.north.east.north?.east, isInSolution: !isInSolution)
        }
        if cell.south.west.cornerState == .whiteStone {
            try update(cell: cell.south.west.south?.west, isInSolution: !isInSolution)
        }
        if cell.south.east.cornerState == .whiteStone {
            try update(cell: cell.south.east.south?.east, isInSolution: !isInSolution)
        }
        
        // Touch the corners
        try touchCorner(corner: cell.north.west)
        try touchCorner(corner: cell.north.east)
        try touchCorner(corner: cell.south.west)
        try touchCorner(corner: cell.south.east)
    }
    
}
