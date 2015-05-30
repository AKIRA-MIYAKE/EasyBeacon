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
    
    public enum Proximity {
        case Unknown
        case Immediate
        case Near
        case Far
    }
    
    public let beacon: CLBeacon
    
    public var proximityUUID: NSUUID {
        return beacon.proximityUUID
    }
    
    public var major: Int {
        return Int(beacon.major.intValue)
    }
    
    public var minor: Int {
        return Int(beacon.minor.intValue)
    }
    
    public var proximity: Proximity {
        switch beacon.proximity {
        case .Unknown:
            return .Unknown
        case .Immediate:
            return .Immediate
        case .Near:
            return .Near
        case .Far:
            return .Far
        }
    }
    
    
    // MARK: - Initialize
    
    public init(beacon: CLBeacon) {
        self.beacon = beacon
    }
    
    
    // MARK: - Hashable
    
    public var hashValue: Int {
        return proximityUUID.hashValue - (major + minor)
    }
    
}

public func ==(lhs: Beacon, rhs: Beacon) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
