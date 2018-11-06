//
//  InputViewController.swift
//  ofo
//
//  Created by Zhang, Frank on 23/05/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    
    var isFlashOn = false
    var isVoiceOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panelView.layer.shadowOffset = CGSize(width: 0, height: 0)
        panelView.layer.shadowRadius = 3
        panelView.layer.shadowOpacity = 0.5
        
        inputTextField.layer.borderWidth = 2
        inputTextField.layer.borderColor = UIColor.ofoColor.cgColor
        
        title = "车辆解锁"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "扫描用车", style: .plain, target: self, action: #selector(backToScan))

        // Do any additional setup after loading the view.
    }
    
    func backToScan() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func flashBtnTap(_ sender: UIButton) {
        isFlashOn = !isFlashOn
        
        if isFlashOn {
            sender.setImage(#imageLiteral(resourceName: "lightopen"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "lightclose"), for: .normal)
        }
    }

    @IBAction func voiceBtnTap(_ sender: UIButton) {
        isVoiceOn = !isVoiceOn
        
        if isVoiceOn {
            sender.setImage(#imageLiteral(resourceName: "voiceopen"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "voiceclose"), for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
