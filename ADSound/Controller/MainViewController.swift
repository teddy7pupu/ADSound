//
//  MainViewController.swift
//  ADSound
//
//  Created by msp310 on 2018/3/22.
//  Copyright © 2018年 msp310. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var _start = false
    var _client: ACRCloudRecognition?
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupLayout(){
        _start = false
        self._client = ACRCloudRecognition(config: configSet())
    }
    
    //MARK: Active
    @IBAction func onStartRecognition(_ sender:AnyObject) {
        if (_start) { return }
        self._client?.startRecordRec()
        self._start = true
    }
    
    @IBAction func onStopRecognition(_ sender:AnyObject) {
        self._client?.stopRecordRec()
        self._start = false
    }
    
    func configSet() -> ACRCloudConfig {
        let config = ACRCloudConfig()
        config.accessKey = "410e8cfb22063226f595225682451abc"
        config.accessSecret = "fdzQjHscmS06nbq6Il6yUFcPdfB1Hm1zmXs8Fl6n"
        config.host = "identify-ap-southeast-1.acrcloud.com"
        config.recMode = rec_mode_remote  //if you want to identify your offline db, set the recMode to "rec_mode_local"
        config.audioType = "recording"
        config.requestTimeout = 10
        config.protocol = "https"
        config.keepPlaying = 2;  //1 is restore the previous Audio Category when stop recording. 2 (default), only stop recording, do nothing with the Audio Category.
        
        if (config.recMode == rec_mode_local || config.recMode == rec_mode_both) {
            config.homedir = Bundle.main.resourcePath!.appending("/acrcloud_local_db")
        }
        
        config.stateBlock = { [weak self] state in self?.handleState(state!) }
        config.volumeBlock = { [weak self] volume in self?.handleVolume(volume) }
        config.resultBlock = {[weak self] result, resType in self?.handleResult(result!, resType: resType) }
        return config
    }
    
    func handleResult(_ result: String, resType: ACRCloudResultType) -> Void
    {
        DispatchQueue.main.async {
            print(result)
            self._client?.stopRecordRec()
            self._start = false
        }
    }
    
    func handleVolume(_ volume: Float) -> Void {
        DispatchQueue.main.async {
            self.volumeLabel.text = String(format: "Volume: %f", volume)
        }
    }
    
    func handleState(_ state: String) -> Void
    {
        DispatchQueue.main.async {
            self.stateLabel.text = String(format:"State : %@",state)
        }
    }
}
