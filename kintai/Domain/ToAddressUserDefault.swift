//
//  ToAddressUserDefault.swift
//  kintai
//
//  Created by kkamakur on 2018/07/05.
//  Copyright © 2018年 KAMAKURAKAZUHIRO. All rights reserved.
//

// Usage
// let toAddress = ToAddressUserDefault().toAddress
// ToAddressUserDefault().toAddress = "hoge"
// Toのアドレス
final class ToAddressUserDefault: BaseUserDefault {
    init() {
        super.init(userDefaultsKey: "udTo")
    }

    var toAddress: String? {
        get {
            return self.getString()
        }

        set {
            self.setString(string: newValue)
        }
    }
}
