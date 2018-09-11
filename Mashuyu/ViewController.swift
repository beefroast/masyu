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
        
        guard let board = Board.instantiate(width: 2, height: 2) else { return }
        
        
        
        
    }
}













struct EdgeCollection {
    let original: Edge
    let adjacent: Edge?
    let perpendicular0: Edge?
    let perpendicular1: Edge?
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

