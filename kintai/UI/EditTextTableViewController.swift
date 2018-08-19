//
//  EditTextTableViewController.swift
//  kintai
//
//  Created by KAMAKURAKAZUHIRO on 2018/05/30.
//  Copyright © 2018年 KAMAKURAKAZUHIRO. All rights reserved.
//

import UIKit
import RealmSwift

class EditTextTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    enum Section: Int, CaseIterable {
        case messageSection = 0
        case addSection
    }
    
    let realm = try! Realm()
    // DB
    var messageArray = try! Realm().objects(MessageText.self).sorted(byKeyPath: "id", ascending: false)

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
        return Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .some(.messageSection):
            return messageArray.count
        case .some(.addSection):
            return 1
        case .none:
            return 0
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
                title : messageArray[indexPath.row].title
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modalViewController = AddMessageViewController()
        let navigationController = UINavigationController(rootViewController: modalViewController)
        present(navigationController, animated: true, completion: nil)
    }
}
