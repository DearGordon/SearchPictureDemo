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

    func delete(_ data: ResultData) {
        let moc = self.managedObjectContext()
        moc.delete(data)
        print("remove data from CoreData")
        self.saveContext(completion: nil)
    }
    
    func saveContext(completion: ((Result<Bool, Error>) -> Void)?) {
        let context = persistentContainer.viewContext
        //FIXME:  context.hasChanges 在我的最愛頁面沒有觸發hasChange
        if context.hasChanges {
            do {
                try context.save()
                print("Save with CoreData Successed")
                completion?(.success(true))
            } catch {
                print(error.localizedDescription)
                completion?(.failure(error))
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
