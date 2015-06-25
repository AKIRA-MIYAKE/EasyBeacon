//
//  BeaconMonitor.swift
//  EasyBeacon
//
//  Created by MiyakeAkira on 2015/05/30.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyEvents

class BeaconMonitor: NSObject, CLLocationManagerDelegate {
    
    // MARK: - let
    
    let usage: Usage
    let available: Available
    let enteringBeaconRegion: EnteringBeaconRegion
    let rangedBeacons: RangedBeacons
    let proximityBeacon: ProximityBeacon
    
    private let manager: CLLocationManager
    private let notificationCenter: NSNotificationCenter
    
    
    // MARK: - Variables
    
    var isRunning: Bool
    
    var regions: Set<BeaconRegion> {
        willSet {
            if isRunning {
                clean()
            }
        }
        
        didSet {
            if isRunning {
                for region in regions {
                    manager.startMonitoringForRegion(region.region)
                }
            }
        }
    }
    
    
    // MARK: - Initialize
    
    init(usage: Usage) {
        self.usage = usage
        
        available = Available(value: false)
        enteringBeaconRegion = EnteringBeaconRegion()
        rangedBeacons = RangedBeacons()
        proximityBeacon = ProximityBeacon()
        
        manager = CLLocationManager()
        notificationCenter = NSNotificationCenter.defaultCenter()
        
        isRunning = false
        regions = Set<BeaconRegion>()
        
        super.init()
        
        initialize()
    }
    
    private func initialize() {
        // Initialize location manager
        
        manager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            switch usage {
            case .Always:
                manager.requestAlwaysAuthorization()
            case .WhenInUse:
                manager.requestWhenInUseAuthorization()
            }
        case .AuthorizedAlways:
            if usage == .Always {
                available.value = true
            }
        case .AuthorizedWhenInUse:
            if usage == .WhenInUse {
                available.value = true
            }
        default:
            break
        }
        
        
        // Initialize notification center
        
        notificationCenter.addObserver(
            self,
            selector: "handleWillEnterForeground:",
            name: UIApplicationWillEnterForegroundNotification,
            object: nil)
        
        notificationCenter.addObserver(
            self,
            selector: "handleDidEnterBackground:",
            name: UIApplicationDidEnterBackgroundNotification,
            object: nil)
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    
    // MARK: - Method
    
    func startMonitoring() {
        if available.value && !isRunning {
            for region in regions {
                manager.startMonitoringForRegion(region.region)
            }
            
            isRunning = true
        }
    }
    
    func stopMonitoring() {
        if isRunning {
            clean()
            
            isRunning = false
        }
    }
    
    func startRanging(region: CLBeaconRegion) {
        if available.value {
            manager.startRangingBeaconsInRegion(region)
        }
    }
    
    func stopRanging(region: CLBeaconRegion) {
        manager.stopRangingBeaconsInRegion(region)
    }
    
    func clean() {
        if let ranged = manager.rangedRegions as? Set<CLBeaconRegion> {
            for region in ranged {
                manager.stopRangingBeaconsInRegion(region)
            }
        }
        
        if let monitored = manager.monitoredRegions as? Set<CLBeaconRegion> {
            for region in monitored {
                manager.stopMonitoringForRegion(region)
            }
        }
    }
    
    
    // MARK: - Selector
    
    func handleWillEnterForeground(notification: NSNotification) {
        switch usage {
        case .Always:
            break
        case .WhenInUse:
            startMonitoring()
        }
    }
    
    func handleDidEnterBackground(notificatoin: NSNotification) {
        switch usage {
        case .Always:
            break
        case .WhenInUse:
            clean()
        }
    }
    
    
    // MARK: - Location manager delegate
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedAlways:
            if usage == .Always {
                available.value = true
            }
        case .AuthorizedWhenInUse:
            if usage == .WhenInUse {
                available.value = true
            }
        default:
            available.value = false
        }
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        manager.requestStateForRegion(region)
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        if let beaconRegion = region as? CLBeaconRegion {
            switch state {
            case .Inside:
                enteringBeaconRegion.value = BeaconRegion(region: beaconRegion)
                startRanging(beaconRegion)
            case .Outside:
                break
            case .Unknown:
                break
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        if let beaconRegion = region as? CLBeaconRegion {
            enteringBeaconRegion.value = BeaconRegion(region: beaconRegion)
            startRanging(beaconRegion)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        if let beaconRegion = region as? CLBeaconRegion {
            enteringBeaconRegion.value = nil
            stopRanging(beaconRegion)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        if let beacons = beacons as? [CLBeacon] {
            rangedBeacons.value = beacons.map { Beacon(beacon: $0) }
            
            var proximity: CLBeacon?
            
            for beacon in beacons {
                if let current = proximity {
                    if current.rssi > beacon.rssi {
                        proximity = beacon
                    }
                } else {
                    proximity = beacon
                }
            }
            
            proximityBeacon.value = proximity.map { Beacon(beacon: $0) }
        }
    }
    
}