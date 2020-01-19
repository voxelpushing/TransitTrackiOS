//
//  ContentView.swift
//  TransitTrack
//
//  Copyright © 2019 Kevin Hua. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var nextBusService = NextBusService()
    @EnvironmentObject var vehicleDatabase: VehicleDatabase
    @State private var vehicle: Vehicle = Vehicle()
    @State private var vehicleNumber: String = ""
    @State private var agency: String = "ttc"
    @State private var isInitalView: Bool = true
    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                TextField("Enter the vehicle number here", text: $vehicleNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    if (!self.vehicleNumber.isEmpty) {
                        self.nextBusService.getVehicleInfo(vehicleNumber: self.vehicleNumber, agency: self.agency)
                        withAnimation {
                            self.isLoading = true
                        }
                    }
                }) {
                    Text("Track")
                }
                .padding([.top, .bottom], 5)
                
                VehicleResponseView(isHistory: false, isInitialView: self.isInitalView, loading: self.isLoading, vehicle: self.vehicle)
                    .onReceive(nextBusService.$vehicleResult, perform: { result in
                        if let result = result {
                            withAnimation {
                                self.isLoading = false
                                switch (result) {
                                case let .success(vehicle):
                                    self.isInitalView = false
                                    self.vehicle = vehicle
                                case .failure:
                                    self.showAlert = true
                                }
                            }
                        }})
                    .padding([.top, .bottom], 5)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text("Please try again later."), dismissButton: .default(Text("Got it!")))
                    }
                
                NavigationLink(destination: HistoryView()) {
                    Text("View All Results")
                }
                .padding([.top, .bottom], 5)
                
                Spacer()
            }
            .padding([.leading, .trailing], 20)
            .navigationBarTitle(Text(Constants.appName))
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
