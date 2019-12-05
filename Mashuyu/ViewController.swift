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
        
        let board = Board.instantiate(width: 5, height: 5)

        board.northWestCell.south.south?.south.west.cornerState = .whiteStone
        board.northWestCell.south.south?.south.east.cornerState = .whiteStone
        board.northWestCell.south.south?.south.south?.south.east.east?.east.cornerState = .whiteStone
        board.northWestCell.east.east?.east.east?.east.south.cornerState = .whiteStone
        board.northWestCell.east.east?.east.east?.east.south.south?.south.south?.south.cornerState = .whiteStone
        board.northWestCell.south.south?.south.south?.south.south?.south.south?.south.west.cornerState = .blackStone
        board.northWestCell.east.east?.east.east?.east.east?.east.south.south?.south.cornerState = .whiteStone
        board.northWestCell.east.east?.east.east?.east.east?.east.south.south?.south.east?.east.cornerState = .whiteStone
        board.northWestCell.east.east?.east.east?.east.east?.east.south.south?.south.east?.east.south?.south.south?.south.cornerState = .whiteStone

        
        print(board.stringRepresentation() + "\n\n\n")
                

        let solver = Solver()

        do {
            let board = try solver.solve(board: board)
            print("Finished board -> ")
            print(board.stringRepresentation())
        } catch (let error) {
            print(error)
        }

        
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

