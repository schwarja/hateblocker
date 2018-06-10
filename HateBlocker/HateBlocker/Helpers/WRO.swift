//
//  WRO.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import Foundation

class WRO<T: AnyObject> {
    weak private(set) var object: T?
    
    init(object: T?) {
        self.object = object
    }
}

/// Wrapper for weak reference
class WROH<T: AnyObject>: Equatable where T: Hashable {
    weak internal(set) var object: T?
    
    init(object: T?) {
        self.object = object
    }
}

extension WROH: Hashable {
    
    var hashValue: Int {
        return object?.hashValue ?? Int.min
    }
}

func == <T>(lhs: WROH<T>, rhs: WROH<T>) -> Bool {
    if lhs.object == rhs.object {
        return true
    }
    
    return false
}
