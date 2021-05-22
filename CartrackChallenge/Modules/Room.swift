//
//  Room.swift
//  CartrackChallenge
//
//  Created by Garri Adrian Nablo on 5/22/21.
//

import Foundation

final class Room {
    static func authenticate(username: String, password: String) -> Bool {
        Database.shared.fetchUser(with: Credential(username: username, password: password)) != nil
    }
}
