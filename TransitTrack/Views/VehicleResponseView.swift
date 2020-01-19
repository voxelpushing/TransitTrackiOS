//
//  VehicleResponseView.swift
//  TransitTrack
//
//  Copyright © 2020 Kevin Hua. All rights reserved.
//

import Foundation
import SwiftUI

struct VehicleResponseView: View {
    
    var isHistory: Bool
    var isInitialView: Bool
    var loading: Bool
    var vehicle: Vehicle
    
    var body: some View {
        Group {
            if self.loading {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            } else {
                VStack(alignment: .leading) {
                    if isInitialView {
                        Text("Enter a vehicle number and start tracking!")
                            .font(.system(size: 20))
                    } else {
                        if self.isHistory {
                            Text(self.vehicle.time.toDateString() )
                                .font(.headline)
                            Text("Vehicle " + (self.vehicle.id ))
                                .padding([.top, .bottom], 3)
                        } else {
                            Text("Vehicle " + (self.vehicle.id ))
                                .font(.headline)
                        }
                        Text(self.getRouteTag())
                            .bold()
                            .padding([.leading, .trailing], 7)
                            .padding([.top, .bottom], 3)
                            .background(
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(Constants().getColorForAgency(agency: self.vehicle.agency) ?? Color.black)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                )
                            .foregroundColor(Color.white)
                        Text(self.vehicle.dirDesc ?? "")
                            .padding([.bottom], 10)
                        
                        HStack {
                            Image(systemName: "location.fill")
                            Text("\(self.vehicle.lat ), \(self.vehicle.lon)")
                                .onTapGesture {
                                    if (!self.vehicle.lat.isEmpty && !self.vehicle.lon.isEmpty) {
                                        if let mapsURL = URL(string: "http://maps.apple.com/?ll=\(self.vehicle.lat),\(self.vehicle.lon)&q=Vehicle+Location") {
                                            UIApplication.shared.open(mapsURL)
                                        }
                                    }
                                }
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding([.leading, .top, .bottom, .trailing])
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.5), lineWidth: 1)
        )
    }
    
    private func getRouteTag() -> String {
        if let tag = self.vehicle.routeTag, !tag.isEmpty {
            return tag
        } else {
            return "Not in service".uppercased()
        }
    }
}

struct VehicleResponseView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleResponseView(isHistory: false, isInitialView: true, loading: false, vehicle: Vehicle())
    }
}
