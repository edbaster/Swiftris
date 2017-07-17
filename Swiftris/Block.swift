//
//  Block.swift
//  Swiftris
//
//  Created by Eduardo Pacheco on 08/06/17.
//  Copyright © 2017 Eduardo Pacheco. All rights reserved.
//

import SpriteKit

let NumberOfColors: UInt32 = 6

enum BlockColor: Int, CustomStringConvertible {
    case Blue = 0, Orange, Purple, Red, Teal, Yellow

    var spriteName: String {
        switch self {
        case .Blue: return "blue"
        case .Orange: return "orange"
        case .Purple: return "purple"
        case .Red: return "red"
        case .Teal: return "teal"
        case .Yellow: return "yellow"
        }
    }

    var description: String {
        return self.spriteName
    }

    static func random() -> BlockColor {
        return BlockColor(rawValue: Int(arc4random_uniform(NumberOfColors)))!
    }
}

class Block: Hashable, CustomStringConvertible {

    // MARK: - Properties
    internal let color: BlockColor
    internal var column: Int
    internal var row: Int
    internal var sprite: SKSpriteNode?
    internal var spriteName: String {
        return color.spriteName
    }
    internal var hashValue: Int {
        return self.column ^ self.row
    }
    internal var description: String {
        return "\(color): [\(column), \(row)]"
    }

    // MARK: - Init
    init(column: Int, row: Int, color: BlockColor) {
        self.column = column
        self.row = row
        self.color = color
    }
}

func ==(lhs: Block, rhs: Block) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
}
