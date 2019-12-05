//
//  Corner.swift
//  Mashuyu
//
//  Created by Benjamin Frost on 11/9/18.
//  Copyright © 2018 Benjamin Frost. All rights reserved.
//

import Foundation



enum CornerState {
    case whiteStone
    case blackStone
}


class Corner: BoardElement {

    var name: String? = nil
    weak var north: VerticalEdge?
    weak var south: VerticalEdge?
    weak var east: HorizontalEdge?
    weak var west: HorizontalEdge?
    var cornerState: CornerState? = nil
    
    init(name: String) {
        self.name = name
    }
    
    
    func numberOfSolutionEdges() -> Int {
        return ((north?.isInSolution == true) ? 1 : 0)
            + ((south?.isInSolution == true) ? 1 : 0)
            + ((east?.isInSolution == true) ? 1 : 0)
            + ((west?.isInSolution == true) ? 1 : 0)
    }
    
    func stringRepresentationRecursive() -> String {
        return self.stringRepresentation() + (self.east?.stringRepresentationRecursive() ?? "")
    }
    
    func oppositeEdge(to: Edge?) -> Edge? {
        guard let e = to else { return nil }
        if e === self.north { return south }
        if e === self.south { return north }
        if e === self.east { return west }
        if e === self.west { return east }
        return nil
    }
    
    func edgesParallel(to: Edge?) -> [Edge] {
        guard let e = to else { return [] }
        if e === self.north || e === self.south { return [east, west].compactMap({ $0 }) }
        if e === self.east || e === self.west { return [north, south].compactMap({ $0 }) }
        return []
    }
    
    var debugDescription: String {
        get { return "Corner: \(name!)" }
    }
    
    func stringRepresentation() -> String {
        switch self.cornerState {
        case nil: return "+"
        case .whiteStone: return "O"
        case .blackStone: return "X"
        }
    }
}
