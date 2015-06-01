//
//  Avairable.swift
//  EasyBeacon
//
//  Created by MiyakeAkira on 2015/05/30.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation
import SwiftyEvents

public typealias Available = _Available<AvailableEvent, Bool>

public enum AvailableEvent {
    case WillUpdate
    case DidUpdate
}

public class _Available<E, A>: EventEmitter<AvailableEvent, Bool> {
    
    // MARK: - Variables
    
    public var value: Bool {
        willSet {
            if value != newValue {
                emit(.WillUpdate, argument: value)
            }
        }
        
        didSet {
            if value != oldValue {
                emit(.DidUpdate, argument: value)
            }
        }
    }
    
    
    // MARK: - Initialize
    
    public init(value: Bool) {
        self.value = value
    }
    
}
