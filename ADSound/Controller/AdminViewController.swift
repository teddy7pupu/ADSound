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
    
    var memberlist: [Member]?
    
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
        MemberManager.sharedInstance().getMemberList(completion: { (list, error) in
            if let member = list { self.memberlist = member }
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
        performSegue(withIdentifier: adDefines.kSegueNewMember, sender: memberlist)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == adDefines.kSegueNewMember, let memberList = sender as? [Member]? {
            let detailView = segue.destination as! NewMemberViewController
            detailView.memberlist = memberList
        }
        if segue.identifier == adDefines.kSegueEditMember, let member = sender as? Member? {
            let detailView = segue.destination as! NewMemberViewController
            detailView.editMember = member
        }
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
        guard let count = memberlist?.count else {return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MemberCell.self) , for: indexPath) as! MemberCell
        cell.layoutCell(memberlist?[indexPath.row].number)
        return cell
    }
    
    //MARK UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: adDefines.kSegueEditMember, sender: memberlist?[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction] = []
        var title = "停用"
        if !memberlist![indexPath.row].online! {
            title = "啟動"
        }
        let quitAction = UITableViewRowAction(style: .destructive, title: title) { (action, indexPath) in
                self.showAlert(message: "確定要\(title)嗎", completion: {
                    tbHUD.show()
                    if title == "停用" {
                        self.memberlist![indexPath.row].online = false
                    } else {
                        self.memberlist![indexPath.row].online = true
                    }
                    self.updateMember(self.memberlist![indexPath.row])
                })
            }
            actions.append(quitAction)
        return actions
    }
}
