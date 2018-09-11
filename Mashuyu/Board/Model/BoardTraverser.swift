//
//  BoardTraverser.swift
//  Mashuyu
//
//  Created by Benjamin Frost on 11/9/18.
//  Copyright © 2018 Benjamin Frost. All rights reserved.
//

import Foundation

enum OrthogonalDirection {
    case north
    case south
    case east
    case west
}

enum RelativeDirection {
    case forwards
    case left
    case right
}

enum EdgeTravelState {
    
    case north(VerticalEdge)
    case south(VerticalEdge)
    case east(HorizontalEdge)
    case west(HorizontalEdge)
    
    var edge: Edge {
        switch self {
        case .north(let e): return e
        case .south(let e): return e
        case .east(let e): return e
        case .west(let e): return e
        }
    }
    
    subscript(direction: RelativeDirection) -> EdgeTravelState? {
        switch direction {
        case .forwards: return self.foward()
        case .left: return self.left()
        case .right: return self.right()
        }
    }
    
    func foward() -> EdgeTravelState? {
        switch self {
        case .north(let e): return e.north.north.map({ .north($0) })
        case .south(let e): return e.south.south.map({ .south($0) })
        case .east(let e): return e.east.east.map({ .east($0) })
        case .west(let e): return e.west.west.map({ .east($0) })
        }
    }
    
    func left() -> EdgeTravelState? {
        switch self {
        case .north(let e): return e.north.west.map({ .west($0) })
        case .south(let e): return e.south.east.map({ .east($0) })
        case .east(let e): return e.east.north.map({ .north($0) })
        case .west(let e): return e.west.south.map({ .south($0) })
        }
    }
    
    func right() -> EdgeTravelState? {
        switch self {
        case .north(let e): return e.north.east.map({ .east($0) })
        case .south(let e): return e.south.west.map({ .west($0) })
        case .east(let e): return e.east.south.map({ .south($0) })
        case .west(let e): return e.west.north.map({ .north($0) })
        }
    }
    
    func `for`(_ fn: (Edge) -> Void) -> Void {
        fn(self.edge)
    }
    
    func collect(in edges: inout [Edge]) -> EdgeTravelState {
        edges.append(self.edge)
        return self
    }
}

extension Corner {
    
    func travel(_ direction: OrthogonalDirection) -> EdgeTravelState? {
        switch direction {
        case .north: return self.north.map({ .north($0) })
        case .south: return self.south.map({ .south($0) })
        case .east: return self.east.map({ .east($0) })
        case .west: return self.west.map({ .west($0) })
        }
    }
}

