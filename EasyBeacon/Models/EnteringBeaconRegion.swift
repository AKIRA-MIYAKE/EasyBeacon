//
//  EnteringBeaconRegion.swift
//  EasyBeacon
//
//  Created by MiyakeAkira on 2015/05/30.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation
import SwiftyEvents

public typealias EnteringBeaconRegion = _EnteringBeaconRegion<EnteringBeaconRegionEvent, BeaconRegion>

public enum EnteringBeaconRegionEvent {
    case Enter
    case Exit
}

public class _EnteringBeaconRegion<E: Hashable, A>: EventEmitter<EnteringBeaconRegionEvent, BeaconRegion> {
    
    // MARK: - Variables
    
    public var value: BeaconRegion? {
        willSet {
            if newValue != value {
                value.map { emit(.Exit, argument: $0) }
            }
        }
        
        didSet {
            if oldValue != value {
                value.map { emit(.Enter, argument: $0) }
            }
        }
    }
    
}
