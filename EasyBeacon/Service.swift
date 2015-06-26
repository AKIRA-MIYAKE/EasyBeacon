//
//  EasyBeacon.swift
//  EasyBeacon
//
//  Created by MiyakeAkira on 2015/05/30.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation

public class Service {
    
    private static var sharedManager: BeaconManager?
    
    public static func setBeaconRegion(beaconRegions: Set<BeaconRegion>, usage: Usage) {
        let monitor = BeaconMonitor(beaconRegions: beaconRegions, usage: usage)
        let manager = BeaconManager(beaconMonitor: monitor)
        
        sharedManager = manager
    }
    
    public static func defaultManager() -> BeaconManager {
        if let manager = sharedManager {
            return manager
        } else {
            let monitor = BeaconMonitor(beaconRegions: [], usage: .Always)
            let manager = BeaconManager(beaconMonitor: monitor)
            
            sharedManager = manager
            
            return manager
        }
    }
    
}