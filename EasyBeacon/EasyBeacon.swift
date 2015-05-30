//
//  EasyBeacon.swift
//  EasyBeacon
//
//  Created by MiyakeAkira on 2015/05/30.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation

public class EasyBeacon {
    
    private static var beaconMonitor: BeaconMonitor?
    private static var working: Working = .Always
    private static var regions: Set<BeaconRegion> = Set<BeaconRegion>()
    
    public static func defaultManager() -> BeaconManager {
        let monitor: BeaconMonitor
        
        if let beaconMonitor = beaconMonitor {
            monitor = beaconMonitor
        } else {
            monitor = BeaconMonitor(regions: regions, working: working)
            beaconMonitor = monitor
        }
        
        monitor.available.on(.DidUpdate) { value in
            monitor.startMonitoring()
        }
        
        if monitor.available.value {
            monitor.startMonitoring()
        }
        
        return BeaconManager(monitor: monitor)
    }
    
    public static func setWorking(working: Working) {
        self.working = working
        
        beaconMonitor = BeaconMonitor(regions: regions, working: working)
    }
    
    public static func setBeaconRegions(regions: Set<BeaconRegion>) {
        self.regions = regions
        
        beaconMonitor = BeaconMonitor(regions: regions, working: working)
    }
    
}
