//
//  NewMemberViewController.swift
//  ADSound
//
//  Created by msp310 on 2018/4/12.
//  Copyright © 2018年 msp310. All rights reserved.
//

import UIKit

class NewMemberViewController: UITableViewController {

    @IBOutlet weak var sidField: UITextField!
    @IBOutlet weak var onlineSwitch: UISwitch!
    @IBOutlet weak var acrIdField: UITextField!
    @IBOutlet weak var domainField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    var memberlist: [Member]?
    var editMember: Member?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }
    
    func setupLayout() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(NewMemberViewController.keyboardDismiss(gesture:)))
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
        
        if let memberInfo = editMember {
            if let online = memberInfo.online { onlineSwitch.isOn =  online }
            if let name = memberInfo.name { nameField.text = name }
            if let email = memberInfo.mail { mailField.text = email }
            if let acrId = memberInfo.acrId { acrIdField.text = acrId }
            if let domain = memberInfo.adDomain { domainField.text = domain }
            if let sid = memberInfo.number { sidField.text = sid }
        }
    }
    
    @IBAction func onAdd(_ sender: Any) {
        if checkSid(safeString(sidField.text)) {
            var newMember: Member = Member()
            if let memberInfo = editMember {
                newMember = memberInfo
            } else {
                newMember.number = safeString(sidField.text)
            }
            newMember.mail = safeString(mailField.text)
            newMember.name = safeString(nameField.text)
            newMember.adDomain = safeString(domainField.text)
            newMember.acrId = safeString(acrIdField.text)
            newMember.online = onlineSwitch.isOn
            update(newMember)
        }
    }
    
    func update(_ newMember: Member){
        tbHUD.show()
        MemberManager.sharedInstance().updateMember(newMember) { (member, error) in
            tbHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func checkSid(_ sid: String?) -> Bool{
        if safeString(sid) == nil {
            self.showAlert(message: "廠商編號為必填項目")
            return false
        }
        if memberlist != nil {
            for item in memberlist! {
                if item.number == sid {
                    self.showAlert(message: "已存在相同廠商編號")
                    return false
                }
            }
        }
        return true
    }
    
    func safeString(_ string: String?) -> String?{
        if string == "" { return nil }
        return string
    }
    
    override func keyboardDismiss(gesture: UITapGestureRecognizer?) {
        self.view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
