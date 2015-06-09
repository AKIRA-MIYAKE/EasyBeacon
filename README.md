EasyBeacon is a library of monitoring / ranging iBeacon.

# Installation
## Carthage
Specify it in your `Cartfile`:  

    github "AKIRA-MIYAKE/EasyBeacon"

# Usage

Creating a Region of Beacon  

    let region = BeaconRegion(
      identifier: regionIdentifier,
      proximityUUID: UUID,
      major: major,
      minor: minor
    )

Adding Target Regions  

    EasyBeacon.setBeaconRegions([region])

Setting When to Working  

    EasyBeacon.setWorking(.Always)

Getting a Manager  

    let manager = EasyBeacon.defaultManager()

Observing a Region Event

    manager.enteringBeaconRegion.on(.Enter) { region in
      // do something
    }

    manager.enteringBeaconRegion.on(.Exit) { region in
      // do something
    }

Observing a Proximity Beacon Event  

    manager.proximityBeacon.on(.WillUpdate) { beacon in
      // do something
    }

    manager.proximityBeacon.on(.DidUpdate) { beacon in
      // do something
    }

