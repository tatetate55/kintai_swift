//
//  ViewController.swift
//  kintai
//
//  Created by KAMAKURAKAZUHIRO on 2016/01/26.
//  Copyright © 2016年 KAMAKURAKAZUHIRO. All rights reserved.
//

import UIKit
import MessageUI
import RealmSwift

var vacationType:Int = 0 //　休みの種類

class ViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var toText: UITextField!
    @IBOutlet weak var ccText: UITextField!
    @IBOutlet weak var myName: UITextField!
    @IBOutlet weak var bossName: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainText: UITextView!
    
    let realm = try! Realm()
    // DB
    var messageArray = try! Realm().objects(messageText.self).sorted(byKeyPath: "id", ascending: false)
    
    @IBOutlet weak var switchVacation: UISegmentedControl!
    
    @IBAction func changeKishoSegment(sender: UISegmentedControl) {
        vacationType = 0//sender.selectedSegmentIndex
//        if (sender.selectedSegmentIndex == 0) {
//            //最初のセグメントが0。セグメント数に合わせて条件分岐を
//            vacationType = 0
//        } else if (sender.selectedSegmentIndex == 1) {
//            vacationType = 0
//        }
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        // udに保存をする
        let ud = UserDefaults.standard
        ud.set(toText.text, forKey: "udTo")
        ud.set(ccText.text, forKey: "udCc")
        ud.set(myName.text, forKey: "udName")
        ud.set(bossName.text, forKey: "udBoss")
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
        
        self.saveAction()
        //メールを送信できるかチェック
        if MFMailComposeViewController.canSendMail()==false {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 「ud」というインスタンスをつくる。
        let ud = UserDefaults.standard
        
        // ここに初期化処理を書く
        // "firstLaunch"をキーに、Bool型の値を保持する
        let dict = ["firstLaunch": true]

        // デフォルト値登録
        // ※すでに値が更新されていた場合は、更新後の値のままになる
        ud.register(defaults: dict)
        // "firstLaunch"に紐づく値がtrueなら(=初回起動)、値をfalseに更新して処理を行う
        if ud.bool(forKey: "firstLaunch") {
            print("初回起動の時だけ呼ばれるよ")
            let message = messageText()
            message.title = "【勤怠】タイトル"
            print(message.title)
            message.message = "タイトルと本文の編集はメニューの編集画面からできます。"
            try! realm.write {
                realm.add(message, update: true)
            }
            ud.set(false, forKey: "firstLaunch")
            
        }
        
        // キーがidの値をとります。
        
        if ud.object(forKey: "udTo") != nil {
            let udTo : String = ud.object(forKey: "udTo") as! String
            toText.text = udTo
        }
        if ud.object(forKey: "udCc") != nil {
            let udCc : String = ud.object(forKey: "udCc") as! String
            ccText.text = udCc
        }
        if ud.object(forKey: "udName") != nil {
            let udName : String = ud.object(forKey: "udName") as! String
            myName.text = udName
        }
        if ud.object(forKey: "udBoss") != nil {
            let udboss : String = ud.object(forKey: "udBoss") as! String
            bossName.text = udboss
        }

        let date: NSDate = NSDate()
        let cal: NSCalendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        let dateComp: NSDateComponents = cal.components(
            [NSCalendar.Unit.weekday],
            from: date as Date
            ) as NSDateComponents
        
        
        // キーidの値を削除
        //ud.removeObjectForKey("id")
        createTitle(myName: myName.text!, dateCate:"午前半休")
        createMainText(myName: myName.text!, bossName: bossName.text!,dateCate:"午前半休")
        
        // Do any additional setup after loading the view, typically from a nib.
        // selfをデリゲートにする
        toText.delegate = self
        ccText.delegate = self
        myName.delegate = self
        bossName.delegate = self
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
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!  // JPロケール
        dateFormatter.dateFormat = "MM/dd"         // フォーマットの指定
        print(dateFormatter.string(from: NSDate() as Date))
        titleLabel.text = "【勤怠】\(dateFormatter.string(from: NSDate() as Date)) \(myName)　\(dateCate)";
    }
    
    func createMainText(myName: String, bossName: String, dateCate: String) {
        

        titleLabel.text = messageArray[vacationType].title
        mainText.text = messageArray[vacationType].message //"\(bossName2)お疲れ様です。\(myName2)\n本日体調不良のため\(dateCate)を取得させてください。\nお忙しいところご迷惑をおかけして大変申し訳ございません。\n\nよろしくお願い致します。"
    }
    
    @IBAction func tapScreen(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismiss(animated: true, completion: nil)
    }
}
