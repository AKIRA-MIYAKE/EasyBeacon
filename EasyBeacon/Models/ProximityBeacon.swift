//
//  ProximityBeacon.swift
//  EasyBeacon
//
//  Created by MiyakeAkira on 2015/05/30.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation
import SwiftyEvents

public typealias ProximityBeacon = _ProximityBeacon<ProximityBeaconEvent, Beacon>

public enum ProximityBeaconEvent {
    case Approached
    case Updated
    case Withdrew
}

public class _ProximityBeacon<E: Hashable, A>: EventEmitter<ProximityBeaconEvent, Beacon> {
    
    // MARK: - Variables
    
    public var value: Beacon? {
        willSet {
            if newValue == nil && value != nil {
                value.map { emit(.Withdrew, argument: $0) }
            }
        }
        
        didSet {
            if oldValue == nil && value != nil {
                value.map { emit(.Approached, argument: $0) }
            } else if oldValue == value {
                if let oldBeacon = oldValue, let beacon = value {
                    if oldBeacon.proximity != beacon.proximity {
                        emit(.Updated, argument: beacon)
                    }
                }
            }
        }
    }
    
}
