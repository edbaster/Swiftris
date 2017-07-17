//
//  Array2D.swift
//  Swiftris
//
//  Created by Eduardo Pacheco on 08/06/17.
//  Copyright © 2017 Eduardo Pacheco. All rights reserved.
//

class Array2D<T> {

    // MARK: - Properties
    let columns: Int
    let rows: Int
    var array: Array<T?>

    // MARK: - Init
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating: nil, count: rows * columns)
    }

    subscript(column: Int, row: Int) -> T? {
        get {
            return array[(row * columns) + column]
        }

        set(newValue) {
            array[(row * columns) + column] = newValue
        }
    }
}
