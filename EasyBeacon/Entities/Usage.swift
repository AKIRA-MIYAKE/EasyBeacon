//
//  Usage.swift
//  EasyBeacon
//
//  Created by MiyakeAkira on 2015/06/10.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation

public enum Usage: String {
    case Always = "Always"
    case WhenInUse = "WhenInUse"
    
    public func toString() -> String {
        return self.rawValue
    }
}