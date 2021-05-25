//
//  Car.swift
//  CartrackChallenge
//
//  Created by Garri Adrian Nablo on 5/24/21.
//

import Foundation
import CoreLocation

struct Car: Decodable {
    
    private enum Keys: String, CodingKey {
        case id
        case name
        case username
        case email
        case address
        case phone
        case website
        case company
        
        enum CompanyKeys: String, CodingKey {
            case name
            case catchPhrase
            case bs
        }
    }
    
    struct Address: Decodable {
        
        private enum AddressKeys: String, CodingKey {
            case street
            case suite
            case city
            case zipcode
            case geo
        }
        
        struct Coordinates: Decodable {
            var lat = ""
            var lng = ""
        }

        var street = ""
        var suite = ""
        var city = ""
        var zipcode = ""
        var geo = Coordinates()
        
        init() {
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: AddressKeys.self)
            street = try container.decode(String.self, forKey: .street)
            suite = try container.decode(String.self, forKey: .suite)
            city = try container.decode(String.self, forKey: .city)
            zipcode = try container.decode(String.self, forKey: .zipcode)
            geo = try container.decodeIfPresent(Coordinates.self, forKey: .geo) ?? Coordinates()
        }
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
        CLLocationCoordinate2D(latitude: Double(address.geo.lat) ?? 0.0, longitude: Double(address.geo.lng) ?? 0.0)
    }
    
    init() {
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        website = try container.decode(String.self, forKey: .website)
        company = try container.decodeIfPresent(Company.self, forKey: .company) ?? Company()
        address = try container.decodeIfPresent(Address.self, forKey: .address) ?? Address()
    }
}
