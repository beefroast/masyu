//
//  Corner.swift
//  Mashuyu
//
//  Created by Benjamin Frost on 11/9/18.
//  Copyright © 2018 Benjamin Frost. All rights reserved.
//

import Foundation




class Corner: BoardElement {

    weak var north: VerticalEdge?
    weak var south: VerticalEdge?
    weak var east: HorizontalEdge?
    weak var west: HorizontalEdge?
    
    func numberOfSolutionEdges() -> Int {
        return ((north?.state == .solution) ? 1 : 0)
            + ((south?.state == .solution) ? 1 : 0)
            + ((east?.state == .solution) ? 1 : 0)
            + ((west?.state == .solution) ? 1 : 0)
    }
    
    func edgesFrom(edge: Edge) -> EdgeCollection? {
        
        if edge === north {
            return EdgeCollection(original: edge, adjacent: south, perpendicular0: east, perpendicular1: west)
            
        } else if edge === south {
            return EdgeCollection(original: edge, adjacent: north, perpendicular0: east, perpendicular1: west)
            
        } else if edge === east {
            return EdgeCollection(original: edge, adjacent: west, perpendicular0: north, perpendicular1: south)
            
        } else if edge === west {
            return EdgeCollection(original: edge, adjacent: east, perpendicular0: north, perpendicular1: south)
            
        } else {
            return nil
        }
    }
}
