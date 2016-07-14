//
//  ViewController.swift
//  kintai
//
//  Created by KAMAKURAKAZUHIRO on 2016/01/26.
//  Copyright © 2016年 KAMAKURAKAZUHIRO. All rights reserved.
//

import UIKit
import MessageUI

var vacationType:Int = 1 //　休みの種類

class ViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var toText: UITextField!
    @IBOutlet weak var ccText: UITextField!
    @IBOutlet weak var myName: UITextField!
    @IBOutlet weak var bossName: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainText: UITextView!
    
    var weekArray: [Double] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    

    @IBOutlet weak var switchVacation: UISegmentedControl!
    
    @IBAction func changeKishoSegment(sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            //最初のセグメントが0。セグメント数に合わせて条件分岐を
            //println("セグメント0")
            createTitle(myName.text!, dateCate:"午前半休")
            createMainText(myName.text!, bossName: bossName.text!, dateCate:"午前半休")
            vacationType = 1
            
        } else if (sender.selectedSegmentIndex == 1) {
            createTitle(myName.text!, dateCate:"全休")
            createMainText(myName.text!, bossName: bossName.text!, dateCate:"全休")
            vacationType = 2
            //println("セグメント1")
        }
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        
        // udに保存をする
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(toText.text, forKey: "udTo")
        ud.setObject(ccText.text, forKey: "udCc")
        ud.setObject(myName.text, forKey: "udName")
        ud.setObject(bossName.text, forKey: "udBoss")
        // キーidの値を削除ud.removeObjectForKey("id")
        if(vacationType == 1){
            createTitle(myName.text!, dateCate:"午前半休")
            createMainText(myName.text!, bossName: bossName.text!, dateCate:"午前半休")
        } else {
            createTitle(myName.text!, dateCate:"午前半休")
            createMainText(myName.text!, bossName: bossName.text!, dateCate:"全休")
        }
        
    }
    
    func saveAction() {
        // udに保存をする
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(toText.text, forKey: "udTo")
        ud.setObject(ccText.text, forKey: "udCc")
        ud.setObject(myName.text, forKey: "udName")
        ud.setObject(bossName.text, forKey: "udBoss")
        // キーidの値を削除ud.removeObjectForKey("id")
        if(vacationType == 1){
            createTitle(myName.text!, dateCate:"午前半休")
            createMainText(myName.text!, bossName: bossName.text!, dateCate:"午前半休")
        } else {
            createTitle(myName.text!, dateCate:"全休")
            createMainText(myName.text!, bossName: bossName.text!, dateCate:"全休")
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
        if toRecipients.containsString(","){
            let toAddressArray = toRecipients.componentsSeparatedByString(",")
            mailViewController.setToRecipients(toAddressArray) //Toアドレスの表示
        } else {
            mailViewController.setToRecipients([toRecipients]) //Toアドレスの表示
        }
        
        if ccRecipients.containsString(","){
            let ccAddressArray = ccRecipients.componentsSeparatedByString(",")
            mailViewController.setCcRecipients(ccAddressArray) //ccアドレスの表示
        } else {
            mailViewController.setCcRecipients([ccRecipients]) //Ccアドレスの表示
        }
        
        mailViewController.setMessageBody(mainTexts, isHTML: false)
        
        self.presentViewController(mailViewController, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 「ud」というインスタンスをつくる。
        let ud = NSUserDefaults.standardUserDefaults()
        // キーがidの値をとります。
        
        if ud.objectForKey("udTo") != nil {
            let udTo : String = ud.objectForKey("udTo") as! String
            toText.text = udTo
        }
        if ud.objectForKey("udCc") != nil {
            let udCc : String = ud.objectForKey("udCc") as! String
            ccText.text = udCc
        }
        if ud.objectForKey("udName") != nil {
            let udName : String = ud.objectForKey("udName") as! String
            myName.text = udName
        }
        if ud.objectForKey("udBoss") != nil {
            let udboss : String = ud.objectForKey("udBoss") as! String
            bossName.text = udboss
        }

        if ud.objectForKey("udWeek") != nil {
            let udWeek : [Double] = ud.objectForKey("udWeek") as! [Double]
            weekArray = udWeek
        }
        
        let date: NSDate = NSDate()
        let cal: NSCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let dateComp: NSDateComponents = cal.components(
            [NSCalendarUnit.Weekday],
            fromDate: date
        )
        
        weekArray[dateComp.weekday-1] = weekArray[dateComp.weekday] + 1.0
        ud.setObject(weekArray, forKey: "udWeek")
        
        
        // キーidの値を削除
        //ud.removeObjectForKey("id")
        createTitle(myName.text!, dateCate:"午前半休")
        createMainText(myName.text!, bossName: bossName.text!,dateCate:"午前半休")
        
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
        
        let dateFormatter = NSDateFormatter()                                   // フォーマットの取得
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")  // JPロケール
        dateFormatter.dateFormat = "MM/dd"         // フォーマットの指定
        print(dateFormatter.stringFromDate(NSDate()))
        titleLabel.text = "【勤怠】\(dateFormatter.stringFromDate(NSDate())) \(myName)　\(dateCate)";
    }
    
    func createMainText(myName: String, bossName: String, dateCate: String) {
        
        var bossName2:String = ""
        if (bossName == ""){
            bossName2 = ""
        } else {
            bossName2 = "\(bossName)さん"
        }
        
        var myName2:String = ""
        if (myName == ""){
            myName2 = ""
        } else {
            myName2 = "\(myName)です。"
        }
        
        
        mainText.text = "\(bossName2)お疲れ様です。\(myName2)\n本日体調不良のため\(dateCate)を取得させてください。\nお忙しいところご迷惑をおかけして大変申し訳ございません。\n\nよろしくお願い致します。"
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
    self.dismissViewControllerAnimated(true, completion: nil)
    }
}