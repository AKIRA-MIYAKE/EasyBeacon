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
    
    let available: Available
    let enteringBeaconRegion: EnteringBeaconRegion
    let rangedBeacons: RangedBeacons
    let proximityBeacon: ProximityBeacon
    
    private let locationManager: CLLocationManager
    private let notificationCenter: NSNotificationCenter
    
    private let beaconRegions: Set<BeaconRegion>
    private let usage: Usage
    
    
    // MARK: - Variables
    
    private var isRunning: Bool
    
    
    // MARK: - Initialzie
    
    init(beaconRegions: Set<BeaconRegion>, usage: Usage) {
        self.beaconRegions = beaconRegions
        self.usage = usage
        
        available = Available(value: false)
        enteringBeaconRegion = EnteringBeaconRegion()
        rangedBeacons = RangedBeacons()
        proximityBeacon = ProximityBeacon()
        
        locationManager = CLLocationManager()
        notificationCenter = NSNotificationCenter.defaultCenter()
        
        isRunning = false
        
        super.init()
        
        initialize()
    }
    
    private func initialize() {
        // Setup location manager
        
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            switch usage {
            case .Always:
                locationManager.requestAlwaysAuthorization()
            case .WhenInUse:
                locationManager.requestWhenInUseAuthorization()
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
        
        clean()
        
        
        // Setup notification center
        
        notificationCenter.addObserver(
            self,
            selector: "handleDidBecomeActive:",
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
        
        notificationCenter.addObserver(
            self,
            selector: "handleDidEnterBackground:",
            name: UIApplicationDidEnterBackgroundNotification,
            object: nil)
        
        // Starting monitor
        
        available.on(.Updated) { value in
            if value {
                self.startMonitoring()
            }
        }
        
        if available.value {
            startMonitoring()
        }
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    
    // MARK: - Private method
    
    private func startMonitoring() {
        let startFlag: Bool
        
        if available.value && !isRunning {
            switch usage {
            case .Always:
                startFlag = true
            case .WhenInUse:
                if UIApplication.sharedApplication().applicationState == .Active {
                    startFlag = true
                } else {
                    startFlag = false
                }
            }
        } else {
            startFlag = false
        }
        
        if startFlag {
            for region in beaconRegions {
                locationManager.startMonitoringForRegion(region.region)
            }
            
            isRunning = true
        }
    }
    
    private func stopMonitoring() {
        if isRunning {
            clean()
            
            isRunning = false
        }
    }
    
    private func clean() {
        if let ranged = locationManager.rangedRegions as? Set<CLBeaconRegion> {
            for region in ranged {
                locationManager.stopRangingBeaconsInRegion(region)
            }
        }
        
        if let monitored = locationManager.monitoredRegions as? Set<CLBeaconRegion> {
            for region in monitored {
                locationManager.stopMonitoringForRegion(region)
            }
        }
    }
    
    
    // MARK: - Selector
    
    func handleDidBecomeActive(notification: NSNotification) {
        switch usage {
        case .Always:
            for region in beaconRegions {
                locationManager.requestStateForRegion(region.region)
            }
        case .WhenInUse:
            startMonitoring()
        }
    }
    
    func handleDidEnterBackground(notification: NSNotification) {
        switch usage {
        case .Always:
            for region in beaconRegions {
                locationManager.stopRangingBeaconsInRegion(region.region)
            }
        case .WhenInUse:
            stopMonitoring()
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
        if let region = region as? CLBeaconRegion {
            switch state {
            case .Inside:
                enteringBeaconRegion.value = BeaconRegion(region: region)
                manager.startRangingBeaconsInRegion(region)
            default:
                break
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        if let region = region as? CLBeaconRegion {
            enteringBeaconRegion.value = BeaconRegion(region: region)
            manager.startRangingBeaconsInRegion(region)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        if let region = region as? CLBeaconRegion {
            manager.stopRangingBeaconsInRegion(region)
            enteringBeaconRegion.value = nil
        }
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        if let beacons  = beacons as? [CLBeacon] {
            rangedBeacons.value = beacons.map { Beacon(beacon: $0) }
            
            var proximity: CLBeacon?
            
            for beacon in beacons {
                if beacon.proximity != .Unknown {
                    if let current = proximity {
                        if current.rssi < beacon.rssi {
                            proximity = beacon
                        }
                    }
                } else {
                    proximity = beacon
                }
            }
        }
    }
    
}