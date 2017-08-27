//
//  Product.swift
//  IteratorTools
//
//  Created by Michael Pangburn on 8/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/**
 Returns an iterator for the Cartesian product of the sequences.
 ```
 let values = product([1, 2, 3], [4, 5, 6, 7], [8, 9])
 // [1, 4, 8], [1, 4, 9], [1, 5, 8], [1, 5, 9], [1, 6, 8], ...
 ```
 - Parameter sequences: The sequences from which to compute the product.
 - Returns: An iterator for the Cartesian product of the sequences.
 */
public func product<S: Sequence>(_ sequences: S...) -> SingleTypeCartesianProductIterator<S> {
    return SingleTypeCartesianProductIterator(sequences)
}


/**
 Returns an iterator for the Cartesian product of two sequences.
 ```
 let values = product(["a", "b"], [1, 2, 3])
 // ("a", 1), ("a", 2), ("a", 3), ("b", 1), ("b", 2), ("b", 3)
 ```
 - Parameters:
    - firstSequence: The first of the two sequences used in computing the product.
    - secondSequence: The second of the two sequences used in computing the product.
 - Returns: An iterator for the Cartesian product of two sequences.
 */
public func product<S1: Sequence, S2: Sequence>(_ firstSequence: S1, _ secondSequence: S2) -> MixedTypeCartesianProductIterator<S1, S2> {
    return MixedTypeCartesianProductIterator(firstSequence, secondSequence)
}


/// An iterator for the Cartesian product of multiple sequences of the same type. See `product(_:)`.
public struct SingleTypeCartesianProductIterator<S: Sequence>: IteratorProtocol, Sequence {

    let sequences: [S]
    var iterators: [S.Iterator]
    var currentValues: [S.Iterator.Element] = []

    init(_ sequences: [S]) {
        self.sequences = sequences
        self.iterators = sequences.map { $0.makeIterator() }
    }

    public mutating func next() -> [S.Iterator.Element]? {
        guard !currentValues.isEmpty else {
            var firstValues: [S.Iterator.Element] = []
            for index in 0..<iterators.count {
                guard let value = iterators[index].next() else {
                    return nil
                }
                firstValues.append(value)
            }
            currentValues = firstValues
            return firstValues
        }

        for index in (0..<currentValues.count).reversed() {
            if let value = iterators[index].next() {
                currentValues[index] = value
                return currentValues
            } else if index == 0 {
                return nil
            } else {
                iterators[index] = sequences[index].makeIterator()
                currentValues[index] = iterators[index].next()!
            }
        }

        return currentValues
    }
}


/// An iterator for the Cartesian product of two sequences of different types. See `product(_:_:)`.
public struct MixedTypeCartesianProductIterator<S1: Sequence, S2: Sequence>: IteratorProtocol, Sequence {

    let secondSequence: S2
    var firstIterator: S1.Iterator
    var secondIterator: S2.Iterator
    var currentFirstElement: S1.Iterator.Element?

    init(_ firstSequence: S1, _ secondSequence: S2) {
        self.secondSequence = secondSequence
        self.firstIterator = firstSequence.makeIterator()
        self.secondIterator = secondSequence.makeIterator()
        self.currentFirstElement = firstIterator.next()
    }

    public mutating func next() -> (S1.Iterator.Element, S2.Iterator.Element)? {
        // Avoid stack overflow
        guard secondSequence.underestimatedCount > 0 else {
            return nil
        }

        guard let firstElement = currentFirstElement else {
            return nil
        }

        guard let secondElement = secondIterator.next() else {
            currentFirstElement = firstIterator.next()
            secondIterator = secondSequence.makeIterator()
            return next()
        }

        return (firstElement, secondElement)
    }
}