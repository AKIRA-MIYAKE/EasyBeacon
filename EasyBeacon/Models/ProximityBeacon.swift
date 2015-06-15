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
            emit(.WillUpdate, value: value)
        }
        
        didSet {
            emit(.DidUpdate, value: value)
        }
    }
    
}
