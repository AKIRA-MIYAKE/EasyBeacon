//
//  Available.swift
//  EasyBeacon
//
//  Created by MiyakeAkira on 2015/06/01.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation
import SwiftyEvents

public typealias Available = _Available<AvailableEvent, Bool>

public enum AvailableEvent {
    case WillUpdate
    case DidUpdate
}

public class _Available<E, V>: EventEmitter<AvailableEvent, Bool> {
    
    // MARK: - Variables
    
    public var value: Bool {
        willSet {
            if value != newValue {
                emit(.WillUpdate, value: value)
            }
        }
        
        didSet {
            if value != oldValue {
                emit(.DidUpdate, value: value)
            }
        }
    }
    
    
    // MARK: - Initialize
    
    public init(value: Bool) {
        self.value = value
        
        super.init()
    }
    
}
