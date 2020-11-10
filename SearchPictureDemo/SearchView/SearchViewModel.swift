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

    

}


extension SearchViewModel: SearchViewModelProtocol {
    
    func pushToResultPage() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: ResultViewKey.viewControllerId) as? ResultViewController {
            print("result didinit")
            vc.view.backgroundColor = .red
            vc.searchInfo = self.dataSource?.searchInfo()
            print("result didnt push")
            //TODO: 這裡不會是datasource
            self.dataSource?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
