////
////  WhiteStoneRule.swift
////  Mashuyu
////
////  Created by Benjamin Frost on 11/9/18.
////  Copyright © 2018 Benjamin Frost. All rights reserved.
////
//
//import Foundation
//
//
//
//class WhiteStoneRule: Rule {
//    
//    typealias RuleElement = Corner
//    
//    
////    func travelFrom(edge: EdgeTravelState, alongPaths paths: [RelativeDirection]) -> [EdgeTravelState] {
////        return paths.compactMap({ (direction) -> EdgeTravelState? in
////            edge[direction]
////        })
////    }
////
////    func expand(edge: [[RelativeDirection]]) -> [[RelativeDirection]] {
////        edge
////    }
////
////    func x(edges: [EdgeTravelState], alongPaths paths: [RelativeDirection]) -> [EdgeTravelState] {
////        edges.flatMap(<#T##transform: (EdgeTravelState) throws -> Sequence##(EdgeTravelState) throws -> Sequence#>)
////    }
////
//    
//    func validate(element: Corner) -> RuleStatus {
//        
//        let corner = element
//        
//        let x = OrthogonalDirection.all.flatMap { (direction) -> [[EdgeTravelState]] in
//            
//            var edgeStates: [Edge]
//            
//            
//            
//            corner.travel(direction)?.collect(in: &edgeStates)
//                .left()?.left()?.foward()
//            
//            
//            edgeStates.append(initialEdgeState)
//            
//            initialEdgeState?.left()?.left()?.collect(in: &<#T##[Edge]#>)
//            
//            initialEdgeState?[]
//
//            let x = paths.map({ (directionList) -> [EdgeTravelState] in
//                let x = directionList.scan(initial: initialEdgeState, combine: { (initialEdgeState, direction) -> EdgeTravelState? in
//                    return initialEdgeState?[direction]
//                }).compactMap({ return $0 })
//                
//                
//            })
//            
//            return x
//        }
//        
//        
////
////
////        let endpoints = OrthogonalDirection.all.compactMap { (direction) -> EdgeTravelState? in
////            corner.travel(direction)
////
////        }
////
////
////
////        let f: (([EdgeTravelState], [[RelativeDirection]]) -> [[Edge]]) = { states, steps in
////
////            return states.map({ (state) -> [Edge] in
////
////                steps.scan(initial: state, combine: <#T##(Result, [RelativeDirection]) -> Result#>)
////
////                steps.scan(initial: state, combine: { (s, directions) -> [Any] in
////
////
////
////                })
////
////
////                let x = steps.map({ (directionList) -> [EdgeTravelState] in
////
////                    let x = directionList.compactMap({ (direction) -> EdgeTravelState? in
////                        return state[direction]
////                    })
////
////                    // After n moves
////
////
////                })
////
////
////            })
////
////        }
//        
////            [].flatMap { (firstPiece) -> [EdgeTravelState] in
////
////                let x = paths[0]
////
////                let c = [firstPiece]
////
////                paths.map({ (directions) -> Any in
////
////                    direction.flatMap({ (direction) -> [EdgeTravelState] in
////
////
////
////                    })
////
////                })
////
////                let y = x.compactMap { (direction) -> EdgeTravelState? in
////                    firstPiece[direction]
////                }
////
////                let a = paths[1]
////
////                let b = a.flatMap { (direction) -> [EdgeTravelState] in
////                    return y.compactMap { (edge) -> EdgeTravelState? in
////                        edge[direction]
////                    }
////                }
////
////                return b
////
////
////
////        }
//        
//        
//        return .incomplete
//        
//    }
//    
//
//        
//}
//    
//    
//
