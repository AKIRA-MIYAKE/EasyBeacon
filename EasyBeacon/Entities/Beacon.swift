//
//  Beacon.swift
//  EasyBeacon
//
//  Created by MiyakeAkira on 2015/05/30.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation
import CoreLocation

public struct Beacon: Hashable {
    
    public enum Proximity: String {
        case Unknown = "Unknown"
        case Immediate = "Immediate"
        case Near = "Near"
        case Far = "Far"
        
        public func toString() -> String {
            return self.rawValue
        }
    }
    
    
    // MARK: - let
    
    public let proximityUUID: NSUUID
    public let major: Int
    public let minor: Int
    
    public let beacon: CLBeacon?
    
    
    // MARK: - Variables
    
    public var proximity: Proximity {
        if let beacon = beacon {
            switch beacon.proximity {
            case .Unknown:
                return Proximity.Unknown
            case .Immediate:
                return Proximity.Immediate
            case .Near:
                return Proximity.Near
            case .Far:
                return Proximity.Far
            }
        } else {
            return Proximity.Unknown
        }
    }
    
    
    // MARK: - Initialzie
    
    public init(proximityUUID: NSUUID, major: Int, minor: Int) {
        self.proximityUUID = proximityUUID
        self.major = major
        self.minor = minor
        
        self.beacon = nil
    }
    
    public init(beacon: CLBeacon) {
        self.beacon = beacon
        
        proximityUUID = beacon.proximityUUID
        major = beacon.major.integerValue
        minor = beacon.minor.integerValue
    }
    
    
    // MARK: - Hashable
    
    public var hashValue: Int {
        return proximityUUID.hashValue - (major + minor)
    }
    
}

public func ==(lhs: Beacon, rhs: Beacon) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
