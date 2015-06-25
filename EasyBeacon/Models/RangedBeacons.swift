//
//  NearBeacons.swift
//  EasyBeacon
//
//  Created by MiyakeAkira on 2015/06/25.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation
import SwiftyEvents

public typealias RangedBeacons = _RangedBeacons<RangedBeaconsEvent, [Beacon]>

public enum RangedBeaconsEvent {
    case WillUpdate
    case DidUpdate
}

public class _RangedBeacons<E: Hashable, V>: EventEmitter<RangedBeaconsEvent, [Beacon]> {
    
    // MARK: - Variables
    
    public var value: [Beacon] {
        willSet {
            emit(.WillUpdate, value: value)
        }
        
        didSet {
            emit(.DidUpdate, value: value)
        }
    }
    
    
    // MARK: - Initialize
    
    public override init() {
        value = [Beacon]()
        
        super.init()
    }
    
}