//
//  VehicleResponse.swift
//  TransitTrack
//
//  Created by Kevin Hua on 2020-01-17.
//  Copyright © 2020 Kevin Hua. All rights reserved.
//

import Foundation

class VehicleResponse {
    let result: Result<Vehicle?, Error>
    
    init(result: Result<Vehicle?, Error>) {
        self.result = result
    }
}
