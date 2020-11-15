//
//  KeyWord.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 26/10/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

enum ResultViewKey {
    static var cellId = "ResultCell"
    static var viewControllerId = "ResultViewController"
}

extension UserDefaults {
    struct CustomKey: RawRepresentable {
        typealias RawValue = String

        var rawValue: String

        init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    func read(key: CustomKey) -> Any? {
        self.value(forKey: key.rawValue)
    }

    func save(key: CustomKey, value: Any) {
        self.setValue(value, forKey: key.rawValue)
    }
}

extension UserDefaults.CustomKey {
    static var favorited = UserDefaults.CustomKey(rawValue: "Favorited")
}
