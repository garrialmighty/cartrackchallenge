//
//  Room.swift
//  CartrackChallenge
//
//  Created by Garri Adrian Nablo on 5/22/21.
//

import Foundation

enum AuthenticationError: Error {
  case invalidCredentials
}

final class Room {
    static func authenticate(username: String, password: String) throws -> Bool {
        guard Database.shared.fetchUser(with: Credential(username: username, password: password)) != nil else {
            throw AuthenticationError.invalidCredentials
        }
        
        return true
    }
}
