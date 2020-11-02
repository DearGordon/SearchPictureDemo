//
//  ViewController.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 26/10/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

protocol SearchViewModelProtocol {

}

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var numberOfCellTextField: UITextField!

    @IBOutlet weak var searchButton: UIButton!
    
    @IBAction func searchButtonAction(_ sender: Any) {
        guard isSearchable else { return }

        self.pushToResultPage()
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Just for checking resultPage
        self.pushToResultPage()
    }

    func pushToResultPage() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: ResultViewKey.viewControllerId) as? ResultViewController {

            vc.view.backgroundColor = .red
            self.navigationController?.pushViewController(vc, animated: true)
        }
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

extension SearchViewController: SearchViewModelDelegate {

}
