//
//  adminViewController.swift
//  ADSound
//
//  Created by msp310 on 2018/3/22.
//  Copyright © 2018年 msp310. All rights reserved.
//

import UIKit
import GoogleSignIn

class AdminViewController: UIViewController
,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var mailLbl: UITextField!
    
    var memberlist: Member?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupLayout() {
        tbHUD.show()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(AdminViewController.keyboardDismiss(gesture:)))
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
        
        getList()
    }
    
    func getList(){
        MemberManager.sharedInstance().getMemberList(completion: { (member, error) in
            if let member = member { self.memberlist = member }
            self.mainTable.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            tbHUD.dismiss()
        })
    }
    
    @IBAction func onSignout(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        UserManager.sharedInstance().signOut()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAdd(_ sender: Any) {
        if mailLbl.text == "" {
            self.showAlert(message: "請確認輸入資訊")
            return
        }
        var list: [String] = []
        if memberlist != nil { list = (memberlist?.mail)! }
        if list.index(of: mailLbl.text!) != nil {
            self.showAlert(message: "帳戶已存在")
            return
        }
        list.append(mailLbl.text!)
        var newMember = Member()
        newMember.mail = list
        updateMember(newMember)
    }
    
    func updateMember(_ newMember: Member?) {
        tbHUD.show()
        MemberManager.sharedInstance().updateMember(newMember) { (member, error) in
            self.getList()
            self.showAlert(message: "更新完成")
        }
    }
    
    override func keyboardDismiss(gesture: UITapGestureRecognizer?) {
        self.view.endEditing(true)
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = memberlist?.mail?.count else {return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MemberCell.self) , for: indexPath) as! MemberCell
        cell.layoutCell(memberlist?.mail?[indexPath.row])
        return cell
    }
    
    //MARK UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction] = []
        let quitAction = UITableViewRowAction(style: .destructive, title: "刪除") { (action, indexPath) in
                self.showAlert(message: "確定要刪除嗎", completion: {
                    tbHUD.show()
                    self.memberlist?.mail?.remove(at: indexPath.row)
                    self.updateMember(self.memberlist)
                })
            }
            actions.append(quitAction)
        
        return actions
    }
}
