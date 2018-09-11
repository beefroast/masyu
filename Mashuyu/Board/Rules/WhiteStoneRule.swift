//
//  WhiteStoneRule.swift
//  Mashuyu
//
//  Created by Benjamin Frost on 11/9/18.
//  Copyright © 2018 Benjamin Frost. All rights reserved.
//

import Foundation

class WhiteStoneRule: Rule {
    
    typealias RuleElement = Corner
    
    
    func validate(element: Corner) -> RuleStatus {
        
//        if element.north?.state == .some(.solution)
        
        
        
        return .incomplete
        
    }
    
    func checkLine(corner: Corner, edge0: Edge?, edge1: Edge?) -> RuleStatus {
        
        var edges: [Edge] = []
        
        corner.travel(.north)?.collect(in: &edges)
            .foward()?.collect(in: &edges)
            .left()?.collect(in: &edges)
        
        guard let x = corner.travel(.north) else { fatalError() }
        
        let y = x[.forwards]?[.left]
        
        
        
//        let x = corner.travel(.north)
//        let y = x?[.forward]
//        
        
        
//        guard let e0 = edge0, let e1 = edge1 else { return RuleStatus.incomplete }
//
//        if e0.state == .solution && e1.state == .solution {
//
//            guard let sideA = e0.opposite(toCorner: corner)?.edgesFrom(edge: e0) else {
//                fatalError()
//            }
//
//            guard let sideB = e1.opposite(toCorner: corner)?.edgesFrom(edge: e1) else {
//                fatalError()
//            }
//
//
        
            
//            let (p0, p1) = e0.perpendicularEdgesFrom(corner: corner)
//            let (p2, p3) = e1.perpendicularEdgesFrom(corner: corner)
            
//            switch
//
//            switch (e0.corners)
            
//        }

        
        return RuleStatus.incomplete
    }
        
}
    
    

