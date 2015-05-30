//
//  ProximityBeacon.swift
//  EasyBeacon
//
//  Created by MiyakeAkira on 2015/05/30.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation
import SwiftyEvents

public class ProximityBeacon: Emittable {
    
    public enum Event {
        case Approached
        case WillUpdate
        case DidUpdate
        case Withdrew
    }
    
    public typealias EventType = Event
    public typealias ArgumentType = Beacon
    public typealias FunctionType = ArgumentType -> Void
    
    
    // MARK: - let
    
    private let emitter = EventEmitter<EventType, ArgumentType>()
    
    // MARK: - Variables
    
    public var value: Beacon? {
        willSet {
            if newValue != value {
                value.map { emit(.Withdrew, argument: $0) }
            } else {
                if let newBeacon = newValue, let beacon = value {
                    if newBeacon.proximity != beacon.proximity {
                        emit(.WillUpdate, argument: beacon)
                    }
                }
            }
        }
        
        didSet {
            if oldValue != value {
                value.map { emit(.Approached, argument: $0) }
            } else {
                if let oldBeacon = oldValue, let beacon = value {
                    if oldBeacon.proximity != beacon.proximity {
                        emit(.DidUpdate, argument: beacon)
                    }
                }
            }
        }
    }
    
    
    // MARK: - Emittable
    
    public func on(event: EventType, _ function: FunctionType) -> Listener<ArgumentType> {
        return emitter.on(event, function)
    }
    
    public func on(event: EventType, listener: Listener<ArgumentType>) -> Listener<ArgumentType> {
        return emitter.on(event, listener: listener)
    }
    
    public func once(event: EventType, _ function: FunctionType) -> Listener<ArgumentType> {
        return emitter.once(event, function)
    }
    
    public func removeListener(event: EventType, listener: Listener<ArgumentType>) {
        emitter.removeListener(event, listener: listener)
    }
    
    public func removeAllListeners() {
        emitter.removeAllListeners()
    }
    
    public func removeAllListeners(events: [EventType]) {
        emitter.removeAllListeners(events)
    }
    
    public func listeners(event: EventType) -> [Listener<ArgumentType>] {
        return emitter.listeners(event)
    }
    
    public func emit(event: EventType, argument: ArgumentType) -> Bool {
        return emitter.emit(event, argument: argument)
    }
    
    public func newListener(function: FunctionType) -> Listener<ArgumentType> {
        return emitter.newListener(function)
    }
    
}
