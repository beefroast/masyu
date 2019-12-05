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
    
    deinit {
        print("Oh no!")
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
