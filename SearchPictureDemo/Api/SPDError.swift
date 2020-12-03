//
//  SPDError.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 3/12/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import Foundation

struct SPDError: Error {

    var message: String
    var originalError: Error?

    internal init(message: String, originalError: Error? = nil) {
        self.message = message
        self.originalError = originalError
    }
}
