//
//  FavorritedViewModel.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 12/11/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit


class FavoritedViewModel: NSObject {

    private var dataArray: [ResultDataProtocol] = []

    /// 從我的最愛中下載下來
    /// - Parameter completion: 下載完我的最愛後
    private func getFavoritResult(completion: @escaping (() -> Void)) {
        CoreDataHelper.shared.loadResultData { (result) in
            switch result {
            case .success(let resultDatas):
                self.dataArray = resultDatas
            case .failure(_):
                print("我沒有拿到值")
            }

            completion()
        }
    }

    func setFakeData() {
        var fakeDataArray: [ResultData] = []

        for _ in 0...4 {
            let moc = CoreDataHelper.shared.managedObjectContext()
            let result = ResultData(context: moc)
            result.title = "測試照片title"
            result.url = "https://live.staticflickr.com/65535/50536401813_1070fcacc5.jpg"
            fakeDataArray.append(result)
        }
        self.dataArray = fakeDataArray
        CoreDataHelper.shared.saveContext()
    }
    
    func getDataFromUserDefault(completion: (() -> Void)) {
        let datas = UserDefaults.standard.read(key: .favorited) as! Data
        do {
            let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(datas)

            guard let data = object as? [ResultData] else {
                print("FakeData casting fail")
                return
            }

            self.dataArray = data
            completion()
        } catch {
            print("unarchive fail \(error.localizedDescription)")
        }
    }

    func addToUserdefault(with fakeDataArray: [ResultData]) {
        do {
            let data: NSData = NSData(bytes: fakeDataArray, length: fakeDataArray.count)
            let encodeObject = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)

            UserDefaults.standard.save(key: .favorited, value: encodeObject)
            print("完成")

        } catch {
            print("轉Data失敗 \(error.localizedDescription)")
        }
    }

}

extension FavoritedViewModel: ResultViewModelProtocol {
    var resultArray: [ResultDataProtocol] {
        return self.dataArray
    }

    var numberOfItemsInSection: Int {
        return self.dataArray.count
    }

    func getPhotosData(completion: @escaping (() -> Void)) {
        
        self.getFavoritResult {
            completion()
        }
    }

    
}
