//
//  BeaconRegion.swift
//  EasyBeacon
//
//  Created by MiyakeAkira on 2015/05/30.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation
import CoreLocation

public struct BeaconRegion: Hashable {
    
    // MARK: - let
    
    public let identifier: String
    public let proximityUUID: NSUUID
    public let major: Int?
    public let minor: Int?
    
    public let region: CLBeaconRegion
    
    
    // MARK: - Initialzie
    
    public init(identifier: String, proximityUUID: NSUUID) {
        self.identifier = identifier
        self.proximityUUID = proximityUUID
        
        major = nil
        minor = nil
        
        region = CLBeaconRegion(proximityUUID: proximityUUID, identifier: identifier)
    }
    
    public init(identifier: String, proximityUUID: NSUUID, major: Int) {
        self.identifier = identifier
        self.proximityUUID = proximityUUID
        self.major = major
        
        minor = nil
        
        region = CLBeaconRegion(proximityUUID: proximityUUID, major: UInt16(major), identifier: identifier)
    }
    
    public init(identifier: String, proximityUUID: NSUUID, major: Int, minor: Int) {
        self.identifier = identifier
        self.proximityUUID = proximityUUID
        self.major = major
        self.minor = minor
        
        region = CLBeaconRegion(
            proximityUUID: proximityUUID,
            major: UInt16(major),
            minor: UInt16(minor),
            identifier: identifier)
    }
    
    public init(region: CLBeaconRegion) {
        self.region = region
        
        identifier = region.identifier
        proximityUUID = region.proximityUUID
        
        if let majorValue = region.major {
            major = majorValue.integerValue
        } else {
            major = nil
        }
        
        if let minorValue = region.minor {
            minor = minorValue.integerValue
        } else {
            minor = nil
        }
    }
    
    
    // MARK: - Hashable
    
    public var hashValue: Int {
        return identifier.hashValue - proximityUUID.hashValue
    }
    
}

public func ==(lhs: BeaconRegion, rhs: BeaconRegion) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
