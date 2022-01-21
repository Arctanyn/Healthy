//
//  StorageManager.swift
//  Healthy
//
//  Created by Малиль Дугулюбгов on 21.01.2022.
//

import Foundation

class StorageManager {
    static var shared = StorageManager()
    
    private let storageKey = "UserHealthParameters"
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private var archiveURL: URL
    
    init() {
        self.archiveURL = documentDirectory.appendingPathComponent("UserParameters").appendingPathExtension("plist")
    }
    
    func save(with user: User) {
        var storedUserParameters = fetchUserParameters()
        storedUserParameters = user
        guard let data = try? PropertyListEncoder().encode(storedUserParameters) else {
            print("User data has not been saved")
            return
        }
        try? data.write(to: archiveURL, options: .noFileProtection)
    }
    
    func fetchUserParameters() -> User {
        guard let data = try? Data(contentsOf: archiveURL) else { return User() }
        guard let user = try? PropertyListDecoder().decode(User.self, from: data) else { return User() }
        return user
    }
    
}
