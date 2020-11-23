//
//  SearchViewModel.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 26/10/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

protocol SearchViewModelDataSource: UIViewController {
    func searchInfo() -> SearchInfo
}

class SearchViewModel: NSObject {

    weak var dataSource: SearchViewModelDataSource?

    init(withDelegate delegate: SearchViewModelDataSource) {
        self.dataSource = delegate
    }

    private func initResultViewController() -> ResultViewController? {

        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: ResultViewKey.viewControllerId) as? ResultViewController else { return nil }
        vc.view.backgroundColor = .red

        if let searchInfo = self.dataSource?.searchInfo() {
            vc.resultMode = .Searching(searchInfo: searchInfo)
        }

        return vc
    }

}


extension SearchViewModel: SearchViewModelProtocol {
    
    func pushToResultPage(from viewController: SearchViewController) {

        guard let vc = self.initResultViewController() else { return }
        //TODO: 這裡不會是datasource
        viewController.navigationController?.pushViewController(vc, animated: true)

    }
}
