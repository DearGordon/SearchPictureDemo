//
//  SearchViewModel.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 26/10/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

protocol SearchViewModelDelegate: class {

}

class SearchViewModel: NSObject {

    weak var delegate: SearchViewModelDelegate?

    init(withDelegate delegate: SearchViewModelDelegate) {
        self.delegate = delegate
    }

    

}


extension SearchViewModel: SearchViewModelProtocol {
    
}
