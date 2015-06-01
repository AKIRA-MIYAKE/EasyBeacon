//
//  EnteringBeaconRegion.swift
//  EasyBeacon
//
//  Created by MiyakeAkira on 2015/05/30.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation
import SwiftyEvents

public class EnteringBeaconRegion: Emittable {
    
    public enum Event {
        case Enter
        case Exit
    }
    
    public typealias EventType = Event
    public typealias ArgumentType = BeaconRegion
    public typealias FunctionType = ArgumentType -> Void
    
    
    // MARK: - let
    
    private let emitter = EventEmitter<EventType, ArgumentType>()
    
    
    // MARK: - Variables
    
    public var value: BeaconRegion? {
        willSet {
            if newValue != value {
                value.map { emit(.Exit, argument: $0) }
            }
        }
        
        didSet {
            if oldValue != value {
                value.map { emit(.Enter, argument: $0) }
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
