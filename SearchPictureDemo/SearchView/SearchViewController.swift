//
//  ViewController.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 26/10/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

protocol SearchViewModelProtocol {
    func pushToResultPage(from viewController: SearchViewController)
}

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var numberOfCellTextField: UITextField!

    @IBOutlet weak var searchButton: UIButton!
    
    @IBAction func searchButtonAction(_ sender: Any) {
        guard isSearchable else { return }
        
        self.viewModel?.pushToResultPage(from: self)
    }

    var viewModel: SearchViewModelProtocol?

    var isSearchable = false {
        didSet {
            self.setSearchButtonColor()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = SearchViewModel(withDelegate: self)
        self.detectTextFieldChanged()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.pushToResultPage(from: self)
    }

    func detectTextFieldChanged() {
        let textFieldArray = [searchTextField, numberOfCellTextField]
        for textField in textFieldArray {
            textField?.addTarget(self, action: #selector(self.checkSearchable), for: .editingChanged)
        }
    }

    @objc func checkSearchable() {
        guard searchTextField.text != "",
            numberOfCellTextField.text != "" else {
                self.isSearchable = false
                return
        }
        self.isSearchable = true
    }

    func setSearchButtonColor() {
        self.searchButton.backgroundColor = isSearchable ? .green : .red
    }

}

extension SearchViewController: SearchViewModelDataSource {

    func searchInfo() -> SearchInfo {
        let text = self.searchTextField.text ?? ""
        let perPage = Int(self.numberOfCellTextField.text ?? "0") ?? 0

        return SearchInfo(text: text, page: 1, perPage: perPage)
    }
}
