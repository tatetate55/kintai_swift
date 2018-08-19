//
//  BaseUserDefault.swift
//  kintai
//
//  Created by kkamakur on 2018/07/05.
//  Copyright © 2018年 KAMAKURAKAZUHIRO. All rights reserved.
//

import Foundation

class BaseUserDefault {
    let userDefaults = UserDefaults.standard
    let userDefaultsKey: String

    init(userDefaultsKey: String) {
        self.userDefaultsKey = userDefaultsKey
    }

    func getString() -> String? {
        return self.userDefaults.string(forKey: self.userDefaultsKey)
    }

    func getInt() -> Int {
        return self.userDefaults.integer(forKey: self.userDefaultsKey)
    }

    func setString(string: String?) {
        self.userDefaults.set(string, forKey: self.userDefaultsKey)
        self.userDefaults.synchronize()
    }

    func setInt(int: Int) {
        self.userDefaults.set(int, forKey: self.userDefaultsKey)
        self.userDefaults.synchronize()
    }

    func destroy() {
        return self.userDefaults.removeObject(forKey: self.userDefaultsKey)
    }
}

