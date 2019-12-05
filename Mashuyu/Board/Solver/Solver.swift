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
        return board
    }
    
    func update(edge: Edge, toIsInSolution: Bool) throws {
        
        print("Updating \(edge) \(ObjectIdentifier(edge))")
        
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
        
        // TODO: Check stones
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

    
    func update(cell: Cell, isInSolution: Bool) throws {
        
        print("Updating \(cell) \(ObjectIdentifier(cell))")
        
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
        
        // TODO: Check stones
        
    }
    
}
