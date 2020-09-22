//
//  BidirectionalCollection+Extension.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/22.
//

import Foundation

extension BidirectionalCollection {
    func makeBidirectionalCollectionLoopIterator() -> BidirectionalCollectionLoopIterator<Self,Index> {
        return BidirectionalCollectionLoopIterator<Self,Index>(collection: self)
    }
}

struct BidirectionalCollectionLoopIterator<C,I> where C:BidirectionalCollection, C.Index == I{
    let collection: C
    var lastGivenIndex: I
    
    init(collection: C) {
        self.collection = collection
        self.lastGivenIndex = collection.index(before: collection.startIndex)
    }
    
    mutating func next() -> C.Element? {
        lastGivenIndex = collection.index(after: lastGivenIndex)
        if lastGivenIndex >= collection.endIndex {
            lastGivenIndex = collection.startIndex
        }
        return  collection[lastGivenIndex]
    }
    
    mutating func previous() -> C.Element? {
        lastGivenIndex = collection.index(before: lastGivenIndex)
        if lastGivenIndex < collection.startIndex {
            lastGivenIndex = collection.index(before: collection.endIndex)
        }
        return collection[lastGivenIndex]
    }
}
