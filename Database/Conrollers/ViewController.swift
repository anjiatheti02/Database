//
//  ViewController.swift
//  Database
//
//  Created by Admin on 19/01/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allUsers = fetchUsers()
        if allUsers.isEmpty{
            loadInitialData()
        }
        
        if let user = self.fetchUser(userName: "Kohli"){
            print(user.userName ?? "None")
        }else{
            print("Not found")
        }
        

        
    }
    
    func loadInitialData() {
        guard let fileName = Bundle.main.path(forResource: "Users", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        guard
            let data = optionalData,
            let json = try? JSONSerialization.jsonObject(with: data),
            let users = json as? [[String: Any]]
            else { return }
        
        var decodedObjects:[Users] = []
        
        for user in users{
            let context = CoreDataStack.shared.context
            if let dbUesr = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context) as? Users {
                dbUesr.userName = user["name"] as? String
                dbUesr.password = user["password"] as? String
                decodedObjects.append(dbUesr)
            }
        }
        
        insertRecordsIntoTable(table: "Uers", decodedObjects: decodedObjects)
    }
    
    func insertRecordsIntoTable(table:String,decodedObjects:[Users]){
        let context = CoreDataStack.shared.context
        do{
            for object in decodedObjects{
                context.insert(object)
                context.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.overwriteMergePolicyType)
                try context.save()
            }
        }
        catch let error as NSError {
            print("Cannot Fetch \(error) and \(error.userInfo)")
        }
    }
    
    func fetchUser(userName:String) -> Users?{
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<Users> = Users.fetchRequest()
        let predicate = NSPredicate(format: "userName == %@", userName)
        fetchRequest.predicate = predicate
        do{
            return try context.fetch(fetchRequest).first
        }
        catch
        {
            fatalError("Fetching from the store failed -- 168 Holiday DAO")
        }
        return nil
    }
    
    func fetchUsers() -> [Users]{
        var allUsers:[Users] = []
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<Users> = Users.fetchRequest()
        do {
            let objects  = try context.fetch(fetchRequest) as? [Users]
            allUsers = objects ?? []
        } catch let error {
            print("ERROR DELETING : \(error)")
        }
        return allUsers
    }
    
    
}

