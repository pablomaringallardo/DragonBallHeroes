//
//  LocalDataManager.swift
//  DragonBallHeroes
//
//  Created by Pablo Marín Gallardo on 22/9/23.
//

import Foundation

final class LocalDataManager {
    
    private static let token = "token"
    
    static let shared = LocalDataManager()
    
    // MARK: - Token
    
    func saveToken(token: String) {
        return UserDefaults.standard.set(token, forKey: Self.token)
    }
    
    func deleteToken() {
        UserDefaults.standard.removeObject(forKey: Self.token)
    }
    
    func getToken() -> String {
        return UserDefaults.standard.string(forKey: Self.token) ?? ""
    }
    
    func isUserLogged() -> Bool {
        return !getToken().isEmpty
    }
}
