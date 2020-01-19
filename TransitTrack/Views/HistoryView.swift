//
//  HistoryView.swift
//  TransitTrack
//
//  Copyright © 2020 Kevin Hua. All rights reserved.
//

import SwiftUI
import RealmSwift

struct HistoryView: View {
    @EnvironmentObject var vehicleDatabase: VehicleDatabase
    
    var body: some View {
        List(vehicleDatabase.vehicles, id: \.primaryKey) { vehicle in
            VehicleResponseView(isHistory: true, isInitialView: false, loading: false, vehicle: vehicle)
        }
        .modifier(HideListDivider())
        .navigationBarTitle("History")
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
