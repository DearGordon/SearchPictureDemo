//
//  ResultViewModel.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 26/10/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

class SearchResultViewModel {

    private var dataArray: [ResultDataProtocol] = []
    private var searchInfo: SearchInfo
    private var currentPage: Int

    init(searchInfo: SearchInfo) {
        self.searchInfo = searchInfo
        self.currentPage = searchInfo.page
    }

    private func loadMoreData(completion: @escaping (() -> Void)) {

        let info: SearchInfo = (text: self.searchInfo.text, page: self.currentPage, perPage: self.searchInfo.perPage)
        do {
            try ApiManager.shared.getData(searchInfo: info, completion: { (result) in
                switch result {

                case .success(let data):
                    guard let data = data else { return }
                    self.dataArray.append(contentsOf: data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                completion()
            })
        } catch {
            print(error.localizedDescription)
        }


    }

    /// 從網路中下載完
    /// - Parameters:
    ///   - searchInfo: 輸入搜尋條件
    ///   - completion: 下載完搜尋結果後
    private func getSearchResult(searchInfo: SearchInfo, completion: @escaping (() -> Void)) {
        
        do {
            try ApiManager.shared.getData(searchInfo: searchInfo, completion: { (result) in
                switch result {
                case .success(let data):
                    if let data = data {
                        self.dataArray = data
                    }

                case .failure(let error):
                    print(error.localizedDescription)
                }
                completion()
            })

        } catch {
            print(error.localizedDescription)
        }
    }

}

extension SearchResultViewModel: ResultViewModelProtocol {

    var resultArray: [ResultDataProtocol] {
        return dataArray
    }

    var numberOfItemsInSection: Int {
        return dataArray.count
    }

    func getPhotosData(isTurnPage: Bool, completion: @escaping (() -> Void)) {

        if isTurnPage {
            self.currentPage += 1
            self.loadMoreData {
                completion()
            }
        } else {
            self.getSearchResult(searchInfo: self.searchInfo) {
                completion()
            }
        }

    }

}
