//
//  BeaconManager.swift
//  EasyBeacon
//
//  Created by MiyakeAkira on 2015/05/30.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation

public class BeaconManager {
    
    // MARK: - let
    
    private let monitor: BeaconMonitor
    
    
    // MARK: - Variables
    
    public var available: Available {
        return monitor.available
    }
    
    public var enteringBeaconRegion: EnteringBeaconRegion {
        return monitor.enteringBeaconRegion
    }
    
    public var proximityBeacon: ProximityBeacon {
        return monitor.proximityBeacon
    }
    
    
    // MARK: - Initialize
    
    init(monitor: BeaconMonitor) {
        self.monitor = monitor
    }
    
}
