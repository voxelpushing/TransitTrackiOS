//
//  Vehicle.swift
//  TransitTrack
//
//  Copyright © 2020 Kevin Hua. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Vehicle: Object, NSCopying {
    
    @objc dynamic var primaryKey = UUID().uuidString
    @objc dynamic var id: String = ""
    @objc dynamic var agency: String = ""
    @objc dynamic var routeTag: String?
    @objc dynamic var dirTag: String?
    @objc dynamic var dirDesc: String?
    @objc dynamic var lat: String = ""
    @objc dynamic var lon: String = ""
    @objc dynamic var time: Double = 0.0
    
    required init() {
        super.init()
    }
    
    convenience init(json: JSON, agency: String, dirDesc: String?, time: Double) {
        self.init()
        let vehicle = json["vehicle"]
        self.id = vehicle["id"].string ?? ""
        self.agency = agency
        self.routeTag = vehicle["routeTag"].string ?? ""
        self.dirTag = vehicle["dirTag"].string ?? ""
        self.lat = vehicle["lat"].string ?? ""
        self.lon = vehicle["lon"].string ?? ""
        self.dirDesc = dirDesc
        self.time = time
    }
    
    override static func primaryKey() -> String? {
        return "primaryKey"
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Vehicle()
        copy.primaryKey = self.primaryKey
        copy.id = self.id
        copy.agency = self.agency
        copy.routeTag = self.routeTag
        copy.dirTag = self.dirTag
        copy.dirDesc = self.dirDesc
        copy.lat = self.lat
        copy.lon = self.lon
        copy.time = self.time
        return copy
    }
}
