//
//  Car.swift
//  CartrackChallenge
//
//  Created by Garri Adrian Nablo on 5/24/21.
//

import Foundation
import CoreLocation

struct Car: Decodable {
    
    struct Address: Decodable {
        struct Coordinates: Decodable {
            var lat = 0.0
            var lng = 0.0
        }
        
        var street = ""
        var suite = ""
        var city = ""
        var zipcode = ""
        var geo = Coordinates()
    }
    
    struct Company: Decodable {
        var name = ""
        var catchPhrase = ""
        var bs = ""
    }
    
    var id = 0
    var name = ""
    var username = ""
    var email = ""
    var address = Address()
    var phone = ""
    var website = ""
    var company = Company()
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: address.geo.lat, longitude: address.geo.lng)
    }
}
