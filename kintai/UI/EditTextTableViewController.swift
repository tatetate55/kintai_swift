//
//  EditTextTableViewController.swift
//  kintai
//
//  Created by KAMAKURAKAZUHIRO on 2018/05/30.
//  Copyright © 2018年 KAMAKURAKAZUHIRO. All rights reserved.
//

import UIKit
//import RealmSwift

class EditTextTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
//    let realm = try! Realm()
//    // DB
//    var messageArray = try! Realm().objects(messageText.self).sorted(byKeyPath: "id", ascending: false)
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // カスタムセルの紐付け

        let nib = UINib(nibName: "MessageSetTableViewCell", bundle: nil) // カスタムセルクラス名で`nib`を作成する
        tableView.register(nib, forCellReuseIdentifier: "MessageSetCellIdentifier")
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1// messageArray.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSetCellIdentifier") as! MessageSetTableViewCell
        //        print(cell)
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSetCellIdentifier", for:indexPath) as? MessageSetTableViewCell else {
                fatalError()
            }
            cell.fill(
                title : "hoge"//messageArray[indexPath.row].title
            )
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = "+メール定型文の追加"
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MessageSetTableViewCell.cellHeight
    }
}
