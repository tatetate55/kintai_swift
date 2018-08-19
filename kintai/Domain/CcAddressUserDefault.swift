//
//  CcAddressUserDefault.swift
//  kintai
//
//  Created by kkamakur on 2018/07/05.
//  Copyright © 2018年 KAMAKURAKAZUHIRO. All rights reserved.
//

// Usage
// let CcAddress = CcAddressUserDefault().ccAddress
// ToAddressUserDefault().toAddress = "hoge"
// Toのアドレス
final class CcAddressUserDefault: BaseUserDefault {
    init() {
        super.init(userDefaultsKey: "udCc")
    }

    var ccAddress: String? {
        get {
            return self.getString()
        }

        set {
            self.setString(string: newValue)
        }
    }
}
