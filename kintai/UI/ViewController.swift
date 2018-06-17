//
//  ViewController.swift
//  kintai
//
//  Created by KAMAKURAKAZUHIRO on 2016/01/26.
//  Copyright © 2016年 KAMAKURAKAZUHIRO. All rights reserved.
//

import UIKit
import MessageUI
import Intents
import IntentsUI
import CoreSpotlight
import MobileCoreServices
//import RealmSwift

var vacationType: Int = 0 //　休みの種類

class ViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var toText: UITextField!
    @IBOutlet weak var ccText: UITextField!
    @IBOutlet weak var myName: UITextField!
    @IBOutlet weak var bossName: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainText: UITextView!
    
    //    let realm = try! Realm()
    // DB
    //    var messageArray = try! Realm().objects(messageText.self).sorted(byKeyPath: "id", ascending: false)
    
    @IBOutlet weak var switchVacation: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSiriDonate()
        // 「userDefault」というインスタンスをつくる。
        let userDefault = UserDefaults.standard
        // ここに初期化処理を書く
        // "firstLaunch"をキーに、Bool型の値を保持する
        let dict = ["firstLaunch": true]
        // デフォルト値登録
        // ※すでに値が更新されていた場合は、更新後の値のままになる
        userDefault.register(defaults: dict)
        // "firstLaunch"に紐づく値がtrueなら(=初回起動)、値をfalseに更新して処理を行う
        //        if ud.bool(forKey: "firstLaunch") {
        //            print("初回起動の時だけ呼ばれるよ")
        //            let message = messageText()
        //            message.title = "【勤怠】タイトル"
        //            print(message.title)
        //            message.message = "タイトルと本文の編集はメニューの編集画面からできます。"
        ////            try! realm.write {
        ////                realm.add(message, update: true)
        ////            }
        //            ud.set(false, forKey: "firstLaunch")
        //
        //        }
        // キーがidの値をとります。
        if let udTo = userDefault.object(forKey: "udTo") as? String {
            toText.text = udTo
        }
        if let udCc = userDefault.object(forKey: "udCc") as? String {
            ccText.text = udCc
        }
        if let udName = userDefault.object(forKey: "udName") as? String {
            myName.text = udName
        }
        if let udBoss = userDefault.object(forKey: "udBoss") as? String {
            bossName.text = udBoss
        }
        let date: NSDate = NSDate()
        let cal: NSCalendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        let dateComp: NSDateComponents = cal.components(
            [NSCalendar.Unit.weekday],
            from: date as Date
            ) as NSDateComponents
        // キーidの値を削除
        //ud.removeObjectForKey("id")
        createTitle(myName: myName.text!, dateCate: "午前半休")
        createMainText(myName: myName.text!, bossName: bossName.text!, dateCate: "午前半休")
        
        // Do any additional setup after loading the view, typically from a nib.
        // selfをデリゲートにする
        toText.delegate = self
        ccText.delegate = self
        myName.delegate = self
        bossName.delegate = self

        //        //最後にセグメント追加
        //        var messageTitleArray:[String] = []
        //        for message in messageArray {
        //            messageTitleArray.append(message.title)
        //        }
        //        switchVacation.changeAllSegmentWithArray(arr: messageTitleArray)
    }

    @IBAction func changeKishoSegment(sender: UISegmentedControl) {
        vacationType = sender.selectedSegmentIndex
    }

    @IBAction func saveButton(sender: AnyObject) {
        // udに保存をする
        let userDefault = UserDefaults.standard
        userDefault.set(toText.text, forKey: "udTo")
        userDefault.set(ccText.text, forKey: "udCc")
        userDefault.set(myName.text, forKey: "udName")
        userDefault.set(bossName.text, forKey: "udBoss")
        // キーidの値を削除ud.removeObjectForKey("id")
        if vacationType == 1 {
            createTitle(myName: myName.text!, dateCate:"午前半休")
            createMainText(myName: myName.text!, bossName: bossName.text!, dateCate:"午前半休")
        } else {
            createTitle(myName: myName.text!, dateCate:"午前半休")
            createMainText(myName: myName.text!, bossName: bossName.text!, dateCate:"全休")
        }
    }

    func saveAction() {
        // udに保存をする
        let ud = UserDefaults.standard
        ud.set(toText.text, forKey: "udTo")
        ud.set(ccText.text, forKey: "udCc")
        ud.set(myName.text, forKey: "udName")
        ud.set(bossName.text, forKey: "udBoss")
        // キーidの値を削除ud.removeObjectForKey("id")
        if(vacationType == 1){
            createTitle(myName: myName.text!, dateCate:"午前半休")
            createMainText(myName: myName.text!, bossName: bossName.text!, dateCate:"午前半休")
        } else {
            createTitle(myName: myName.text!, dateCate:"全休")
            createMainText(myName: myName.text!, bossName: bossName.text!, dateCate:"全休")
        }
    }
    
    @IBAction func sendButton(sender: AnyObject) {
        // mailCore
        
        let intent = SendMailIntent()
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate() { _ in
            print("Donated!")
        }
        
        
        self.saveAction()
        //メールを送信できるかチェック
        if MFMailComposeViewController.canSendMail() == false {
            print("Email Send Failed")
            return
        }
        
        let mailViewController = MFMailComposeViewController()
        let toRecipients = self.toText.text!
        let ccRecipients =  self.ccText.text!
        let mainTexts:String = self.mainText.text!
        
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject(self.titleLabel.text!)
        if toRecipients.contains(",") {
            let toAddressArray = toRecipients.components(separatedBy: ",")
            mailViewController.setToRecipients(toAddressArray) //Toアドレスの表示
        } else {
            mailViewController.setToRecipients([toRecipients]) //Toアドレスの表示
        }

        if ccRecipients.contains(",") {
            let ccAddressArray = ccRecipients.components(separatedBy: ",")
            mailViewController.setCcRecipients(ccAddressArray) //ccアドレスの表示
        } else {
            mailViewController.setCcRecipients([ccRecipients]) //Ccアドレスの表示
        }

        mailViewController.setMessageBody(mainTexts, isHTML: false)
        self.present(mailViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // selfをデリゲートにしているので、ここにデリゲートメソッドを書く
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    // タイトルを作成
    func createTitle(myName: String, dateCate: String ) {

        let dateFormatter = DateFormatter()                                   // フォーマットの取得
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale?  // JPロケール
        dateFormatter.dateFormat = "MM/dd"         // フォーマットの指定
        print(dateFormatter.string(from: NSDate() as Date))
        titleLabel.text = "【勤怠】\(dateFormatter.string(from: NSDate() as Date)) \(myName)　\(dateCate)";
    }

    func createMainText(myName: String, bossName: String, dateCate: String) {
        
        
        titleLabel.text = "今日休む"//messageArray[vacationType].title
        mainText.text = "hogeさんお疲れ様です。\n本日体調不良のため\n全休を取得させてください。\nお忙しいところご迷惑をおかけして大変申し訳ございません。\n\nよろしくお願い致します。" //messageArray[vacationType].message //
    }

    @IBAction func tapScreen(sender: AnyObject) {
        self.view.endEditing(true)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }

    func addSiriDonate() {
        // How to donate a shortcut
        let userActivity = NSUserActivity(activityType: "com.kintai.siri")
        userActivity.isEligibleForSearch = true
        userActivity.isEligibleForPrediction = true
        userActivity.title = "勤怠アプリでsiriに話しかけるフレーズ"
        userActivity.userInfo = ["key": "value"]
        userActivity.isEligibleForSearch = true
        userActivity.isEligibleForPrediction = true
        userActivity.suggestedInvocationPhrase = "今日休む"
        
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        let image = UIImage(named: "beach")!
        attributes.thumbnailData = image.pngData()
        attributes.contentDescription = "siriからアプリを起動して素早く休もう！"
        userActivity.contentAttributeSet = attributes
        
        self.userActivity = userActivity
    }
}

extension UISegmentedControl {
    func changeAllSegmentWithArray(arr: [String]){
        self.removeAllSegments()
        for str in arr {
            self.insertSegment(withTitle: str, at: self.numberOfSegments, animated: false)
        }
        self.selectedSegmentIndex = 0
    }
    
}
