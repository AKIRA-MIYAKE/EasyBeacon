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
    
    private let beaconMonitor: BeaconMonitor
    
    
    // MARK: - Variables
    
    public var available: Available {
        return beaconMonitor.available
    }
    
    public var enteringBeaconRegion: EnteringBeaconRegion {
        return beaconMonitor.enteringBeaconRegion
    }
    
    public var rangedBeacons: RangedBeacons {
        return beaconMonitor.rangedBeacons
    }
    
    public var proximityBeacon: ProximityBeacon {
        return beaconMonitor.proximityBeacon
    }
    
    
    // MARK: - Initialize
    
    init(beaconMonitor: BeaconMonitor) {
        self.beaconMonitor = beaconMonitor
    }
    
}