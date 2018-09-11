//
//  Rule.swift
//  Mashuyu
//
//  Created by Benjamin Frost on 11/9/18.
//  Copyright © 2018 Benjamin Frost. All rights reserved.
//

import Foundation


enum RuleStatus {
    case valid
    case invalid
    case incomplete
}

extension RuleStatus {
    
    static func combine(lhs: RuleStatus, rhs: RuleStatus) -> RuleStatus {
        switch (lhs, rhs) {
        case (.valid, .valid): return .valid
        case (.invalid, _): return .invalid
        case (_, .invalid): return .invalid
        default: return .incomplete
        }
    }
}


protocol Rule {
    associatedtype RuleElement: BoardElement
    func validate(element: RuleElement) -> RuleStatus
}


//extension Array: Rule where Element: Rule {
//    func validate(element: RuleElement) -> RuleStatus {
//        return self.reduce(.incomplete) { (result, rule) -> RuleStatus in
//            let x = rule.validate(element: element)
//            return RuleStatus.combine(lhs: result, rhs: x)
//        }
//    }
//}







//enum WhiteStoneInvalidationReason : Error {
//    case tooManyEdges
//}
//
