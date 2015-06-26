//
//  ProximityBeacon.swift
//  EasyBeacon
//
//  Created by MiyakeAkira on 2015/05/30.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation
import SwiftyEvents

public typealias ProximityBeacon = _ProximityBeacon<ProximityBeaconEvent, Beacon?>

public enum ProximityBeaconEvent {
    case WillUpdate
    case DidUpdate
}

public class _ProximityBeacon<E: Hashable, V>: EventEmitter<ProximityBeaconEvent, Beacon?> {
    
    // MARK: - Variables
    
    public var value: Beacon? {
        willSet {
            if value != newValue {
                emit(.WillUpdate, value: value)
            } else {
                if let beacon = value, let newBeacon = newValue {
                    if beacon.proximity != newBeacon.proximity {
                        emit(.WillUpdate, value: value)
                    }
                }
            }
        }
        
        didSet {
            if value != oldValue {
                emit(.DidUpdate, value: value)
            } else {
                if let beacon = value, let oldBeacon = oldValue {
                    if beacon.proximity != oldBeacon.proximity {
                        emit(.DidUpdate, value: value)
                    }
                }
            }
        }
    }
    
}