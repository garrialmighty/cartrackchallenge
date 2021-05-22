//
//  Database.swift
//  CartrackChallenge
//
//  Created by Garri Adrian Nablo on 5/22/21.
//

import CoreData
import Foundation

final class Database {
    
    static let shared = Database()
    
    private init() {
        preloadData()
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CartrackChallenge")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                let nserror = error as NSError
                print("Error saving: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchUser(with credential: Credential) -> User? {
        do {
            let request  = NSFetchRequest<User>(entityName: "User")
            let results = try persistentContainer.viewContext.fetch(request)
            return results
                .filter({
                    $0.username == credential.username && $0.password == credential.password
                })
                .first
        } catch {
            return nil
        }
    }
}

// MARK: - Private
extension Database {
    
    /// Loads users.csv file and saves hardcoded credentials to db
    // TODO: bundle a db instead of injecting data
    @available(iOS, deprecated: 12.1)
    private func preloadData() {
        guard let csvURL = Bundle.main.url(forResource: "users", withExtension: "csv") else { return }
        
        var data = ""
        do {
            data = try String(contentsOf: csvURL)
        } catch {
            print("Error preloading: \(error)")
            return
        }
        
        var rows = data.components(separatedBy: "\n")
        
        // remove last line feed
        rows.removeLast()
        
        var credentials = [Credential]()
        rows.forEach { row in
            let column = row.components(separatedBy: ",")
            let username = column[0]
            let password = column[1]
            credentials.append(Credential(username: username, password: password))
        }
        
        purgeUsers()
        
        let context = persistentContainer.viewContext
        credentials.forEach {
            let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
            user.username = $0.username
            user.password = $0.password
        }
        
        saveContext()
    }
    
    @available(iOS, deprecated: 12.1)
    private func purgeUsers() {
        let request = NSFetchRequest<User>(entityName: "User")
        let context = persistentContainer.viewContext
        do {
            let users = try context.fetch(request)
            users.forEach {
                context.delete($0)
            }
        } catch {
            print("Error deleting: \(error)")
        }
    }
}
