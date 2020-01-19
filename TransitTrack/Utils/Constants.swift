//
//  Constants.swift
//  TransitTrack
//
//  Copyright © 2020 Kevin Hua. All rights reserved.
//

import Foundation
import SwiftUI

struct Constants {
    static let nextBusAPIBaseUrl = "http://webservices.nextbus.com/service/"
    static let vehicleLocationUrl = nextBusAPIBaseUrl + "publicJSONFeed?command=vehicleLocation"
    static let routeConfigUrl = nextBusAPIBaseUrl + "publicJSONFeed?command=routeConfig"
    static let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
    
    private let colorDict = ["ttc": Color(red: 218/255, green: 37/255, blue: 29/255)]
    
    func getColorForAgency(agency: String) -> Color? {
        return colorDict[agency] ?? nil
    }
}
