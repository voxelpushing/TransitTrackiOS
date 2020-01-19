//
//  NextBusService.swift
//  TransitTrack
//
//  Copyright © 2020 Kevin Hua. All rights reserved.
//

import Foundation
import Combine
import Alamofire
import SwiftyJSON
import RealmSwift

class NextBusService : ObservableObject {
    
    @Published var vehicleResult: Result<Vehicle, Error>?
    var cancellables = Set<AnyCancellable>()
    
    func getVehicleInfo(vehicleNumber: String, agency: String) {
        getVehicleStatus(vehicleNumber: vehicleNumber, agency: agency)
        .subscribe(on: DispatchQueue.global())
        .flatMap { [weak self] vehicleStatusJSON in
            self?.getVehicleRouteName(vehicleRawJSON: vehicleStatusJSON, agency: agency) ??
                 Future<Vehicle, Error> { promise in promise(.failure(NSError(domain: "Cannot get route desc", code: 0)))}
        }
        .receive(on: OperationQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
            switch(completion) {
            case let .failure(error):
                self?.vehicleResult = Result.failure(error)
            case .finished:
                break
            }
        }, receiveValue: { [weak self] vehicle in
            self?.vehicleResult = Result.success(vehicle.copy() as! Vehicle)
            self?.saveVehicle(vehicle: vehicle)
        })
        .store(in: &cancellables)
    }
    
    private func getVehicleStatus(vehicleNumber: String, agency: String) -> Future<JSON, Error> {
        let parameters = ["a": "ttc", "v": vehicleNumber]
        return Future { promise in
            AF.request(Constants.vehicleLocationUrl, method: .get, parameters: parameters)
                .validate()
                .responseData { responseData in
                    switch responseData.result {
                    case let .success(data):
                        let json = JSON(data)
                        if (json.isNextBusError()) {
                            promise(.failure(NSError(domain: "Wrong vehicle code", code: 0)))
                            break
                        }
                        promise(.success(JSON(data)))
                    case let .failure(error):
                        promise(.failure(error))
                    }
            }
        }
    }
    
    private func getVehicleRouteName(vehicleRawJSON: JSON, agency: String) -> Future<Vehicle, Error> {
        return Future { promise in
            let routeTag = vehicleRawJSON["vehicle"]["routeTag"].string ?? ""
            let dirTag = vehicleRawJSON["vehicle"]["dirTag"].string ?? ""
            let parameters = ["a": "ttc", "r": String(routeTag)]
            
            if (routeTag == "" || dirTag == "") {
                promise(.success(Vehicle(json: vehicleRawJSON, agency: agency, dirDesc: "", time: NSDate.timeIntervalSinceReferenceDate)))
            } else {
                AF.request(Constants.routeConfigUrl, method: .get, parameters: parameters)
                    .validate()
                    .responseData { responseData in
                        switch responseData.result {
                        case let .success(data):
                            let routeJson = JSON(data)
                            if (routeJson.isNextBusError()) {
                                promise(.failure(NSError(domain: "Wrong route tag", code: 0)))
                                break
                            }
                            let directions = routeJson["route"]["direction"].arrayValue
                            let filteredDirections = directions.filter { direction in
                                direction["tag"].string ?? "" == dirTag
                            }
                            let description = filteredDirections.first?["title"].string
                            promise(.success(Vehicle(json: vehicleRawJSON, agency: agency, dirDesc: description, time: NSDate.timeIntervalSinceReferenceDate)))
                        case let .failure(error):
                            promise(.failure(error))
                        }
                }
            }
        }
    }
    
    private func saveVehicle(vehicle: Vehicle) {
        //let vehicleRef = ThreadSafeReference(to: vehicle)
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                //guard let vehicle = realm.resolve(vehicleRef) else { return }
                try! realm.write {
                    realm.add(vehicle)
                }
            }
        }
    }
}
