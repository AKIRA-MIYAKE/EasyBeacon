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
    
    enum FailEvent {
        case DidFail
    }
    
    
    // MARK: - let
    
    let failEmitter = EventEmitter<FailEvent, NSError>()
    
    let regions: Set<BeaconRegion>
    let usage: Usage
    
    let available: Available
    let enteringBeaconRegion: EnteringBeaconRegion
    let proximityBeacon: ProximityBeacon
    
    
    private let notificationCenter = NSNotificationCenter.defaultCenter()
    
    private let manager: CLLocationManager
    private let clRegions: Set<CLBeaconRegion>
    
    
    // MARK: - Variables
    
    var isRunning: Bool
    
    
    // MARK: - Initialize
    
    init(regions: Set<BeaconRegion>, usage: Usage) {
        self.regions = regions
        self.usage = usage
        
        manager = CLLocationManager()
        
        var clRegions = Set<CLBeaconRegion>()
        for region in regions {
            clRegions.insert(region.region)
        }
        self.clRegions = clRegions
        
        available = Available(value: false)
        enteringBeaconRegion = EnteringBeaconRegion()
        proximityBeacon = ProximityBeacon()
        
        isRunning = false
        
        super.init()
        
        /* Setup location manager */
        manager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways:
            if usage == .Always {
                available.value = true
            }
        case .AuthorizedWhenInUse:
            if usage == .WhenInUse {
                available.value = false
            }
        case .NotDetermined:
            switch usage {
            case .Always:
                manager.requestAlwaysAuthorization()
            case .WhenInUse:
                manager.requestWhenInUseAuthorization()
            }
        default:
            break
        }
        
        notificationCenter.addObserver(
            self,
            selector: "handleWillEnterForgroundNotification:",
            name: UIApplicationWillEnterForegroundNotification,
            object: nil)
        
        notificationCenter.addObserver(
            self,
            selector: "handleDidEnterBackgroundNotification:",
            name: UIApplicationDidEnterBackgroundNotification,
            object: nil)
        
        clean()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    
    // MARK: - Method
    
    func startMonitoring() {
        if available.value && !isRunning {
            for region in clRegions {
                manager.startMonitoringForRegion(region)
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
    
    func handleWillEnterForgroundNotification(notification: NSNotification) {
        switch usage {
        case .Always:
            break
        case .WhenInUse:
            startMonitoring()
        }
    }
    
    func handleDidEnterBackgroundNotification(notfication: NSNotification) {
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
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        if let error = error {
            failEmitter.emit(.DidFail, argument: error)
        } else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            failEmitter.emit(.DidFail, argument: error)
        }
    }
    
}
