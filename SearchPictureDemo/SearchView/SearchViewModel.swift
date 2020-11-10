//
//  SearchViewModel.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 26/10/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

protocol SearchViewModelDelegate: UIViewController {

}

class SearchViewModel: NSObject {

    weak var delegate: SearchViewModelDelegate?

    init(withDelegate delegate: SearchViewModelDelegate) {
        self.delegate = delegate
    }

    

}


extension SearchViewModel: SearchViewModelProtocol {
    
    func pushToResultPage() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: ResultViewKey.viewControllerId) as? ResultViewController {
            
            vc.view.backgroundColor = .red
            self.delegate?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
