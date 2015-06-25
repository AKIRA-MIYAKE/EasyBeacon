//
//  EasyBeacon.swift
//  EasyBeacon
//
//  Created by MiyakeAkira on 2015/05/30.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation
import CoreLocation

public class Service {
    
    public static private (set) var usage: Usage = .Always
    
    private static var sharedMonitor: BeaconMonitor?
    
    public static func setUsage(usage: Usage) {
        self.usage = usage
        sharedMonitor = BeaconMonitor(usage: usage)
    }
    
    public static func setBeaconRegions(regions: Set<BeaconRegion>) {
        if let monitor = sharedMonitor {
            monitor.regions = regions
        } else {
            let monitor = BeaconMonitor(usage: usage)
            monitor.regions = regions
            
            sharedMonitor = monitor
        }
    }
    
    public static func defaultManager() -> BeaconManager {
        if let monitor = sharedMonitor {
            return BeaconManager(monitor: monitor)
        } else {
            let monitor = BeaconMonitor(usage: usage)
            
            sharedMonitor = monitor
            
            return BeaconManager(monitor: monitor)
        }
    }
    
}