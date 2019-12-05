//
//  ViewController.swift
//  Mashuyu
//
//  Created by Benjamin Frost on 9/9/18.
//  Copyright © 2018 Benjamin Frost. All rights reserved.
//

import UIKit


enum InvalidStateError: Error {
    case cornerError(Corner)
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let board = Board.instantiate(width: 6, height: 6) else { return }

        print(board.stringRepresentation())
        
        
        
        
        let edge = board.northWestCell.west

        let solver = Solver()

        do {
            try solver.update(edge: edge, toIsInSolution: true)
            try solver.update(edge: board.northWestCell.east, toIsInSolution: true)
        } catch (let error) {
            print(error)
        }

        print(board.stringRepresentation())

        assert(board.northWestCell.isInsideSolution == true)
        
        
    }
}













extension Sequence {
    
    func scan<Result>(initial: Result, combine: (Result, Element) -> Result) -> [Result] {
        
        var results: [Result] = [initial]
        var cur = initial
        
        for next in self {
            cur = combine(cur, next)
            results.append(cur)
        }
        
        return results
    }
}




extension Array {
    
    func mapPairs<T>(_ fn: (Element, Element) -> T) -> [T] {
        var previousElement: Element? = nil
        return self.compactMap { (right) -> T? in
            if let left = previousElement {
                previousElement = right
                return fn(left, right)
            } else {
                previousElement = right
                return nil
            }
        }
    }
    

}

extension Sequence {
    func forPairs(_ fn: (Element, Element) -> Void) -> Void {
        var previousElement: Element? = nil
        for right in self {
            if let left = previousElement {
                fn(left, right)
            }
            previousElement = right
        }
    }
}

