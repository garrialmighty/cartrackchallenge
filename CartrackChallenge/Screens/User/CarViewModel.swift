//
//  CarViewModel.swift
//  CartrackChallenge
//
//  Created by Garri Adrian Nablo on 5/24/21.
//

import Foundation

struct CarViewModel {
    func logout() {
        UserDefaults.standard.setValue(false, forKeyPath: hasLoggedInKey)
        NotificationCenter.default.post(name: .loggedOut, object: nil)
    }
}
