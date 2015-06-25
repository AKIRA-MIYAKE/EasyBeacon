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

public class _EnteringBeaconRegion<E: Hashable, V>: EventEmitter<EnteringBeaconRegionEvent, BeaconRegion> {
    
    // MARK: Variables
    
    public var value: BeaconRegion? {
        willSet {
            if let region = value {
                emit(.Exit, value: region)
            }
        }
        
        didSet {
            if let region = value {
                emit(.Enter, value: region)
            }
        }
    }
    
}