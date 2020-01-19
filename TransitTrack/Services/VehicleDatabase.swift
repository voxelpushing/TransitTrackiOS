//
//  VehicleDatabase.swift
//  TransitTrack
//
//  Copyright © 2020 Kevin Hua. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import RealmSwift

class VehicleDatabase: ObservableObject {
    private var notificationToken: NotificationToken?
    private var results = try! Realm().objects(Vehicle.self).sorted(byKeyPath: "time", ascending: false)
    @Published var vehicles: [Vehicle] = []
    
    init() {
        self.notificationToken = results.observe { [weak self] _ in
            if let selfie = self {
                selfie.vehicles = Array(selfie.results)
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
