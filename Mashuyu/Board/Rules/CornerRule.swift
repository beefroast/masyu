//
//  CornerRule.swift
//  Mashuyu
//
//  Created by Benjamin Frost on 11/9/18.
//  Copyright © 2018 Benjamin Frost. All rights reserved.
//

import Foundation

class CornerRule: Rule {
    
    typealias RuleElement = Corner
    
    func validate(element: Corner) -> RuleStatus {
        
        // Ensure that we've got exactly two solution edges
        
        switch element.numberOfSolutionEdges() {
        case 0: return .valid
        case 1: return .incomplete
        case 2: return .valid
        default: return .invalid
        }
    }
    
    
    
}
