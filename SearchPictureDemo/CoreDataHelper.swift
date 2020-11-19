//
//  CoreDataHelper.swift
//
//  Created by Vincent on 2018/03/15.
//
import UIKit
import CoreData

class CoreDataHelper: NSObject {
    static let shared = CoreDataHelper()

    override internal init() {}

    func managedObjectContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "ResultData")
        let description = NSPersistentStoreDescription()
        //設定sqlite存放位置
        var sqlUrl = URL(fileURLWithPath: NSHomeDirectory())
        sqlUrl.appendPathComponent("Documents")
        sqlUrl.appendPathComponent("ResultData.sqlite")
        description.url = sqlUrl
        //如果要關閉journal mode，只產生一個sqlite檔案，可以打開以下這個選項
        description.setOption(["journal_mode":"DELETE"] as NSDictionary, forKey: NSSQLitePragmasOption)
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func loadResultData(completion: @escaping ((Result<[ResultData], Error>) -> Void)) {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let request = NSFetchRequest<ResultData>(entityName: "ResultData")

        moc.perform {
            do {
                let dataArray = try moc.fetch(request)
                completion(.success(dataArray))
            } catch {
                completion(.failure(error))
            }
        }
    }

}
