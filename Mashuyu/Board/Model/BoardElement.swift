//
//  BoardElement.swift
//  Mashuyu
//
//  Created by Benjamin Frost on 11/9/18.
//  Copyright © 2018 Benjamin Frost. All rights reserved.
//

import Foundation


protocol BoardElement: IPrintable {
    
    associatedtype Vertical
    associatedtype Horizontal
    
    var north: Vertical { get }
    var south: Vertical { get }
    var east: Horizontal { get }
    var west: Horizontal { get }
    
}

protocol IPrintable {
    func stringRepresentation() -> String
    func stringRepresentationRecursive() -> String
}
