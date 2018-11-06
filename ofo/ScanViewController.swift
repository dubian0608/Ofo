//
//  ScanViewController.swift
//  ofo
//
//  Created by Zhang, Frank on 19/05/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit
import swiftScan

class ScanViewController: LBXScanViewController {
    
    var isFlashOn = false
    

    @IBOutlet weak var panelView: UIView!
    
    @IBAction func flashButTap(_ sender: UIButton) {
        isFlashOn = !isFlashOn
        
        scanObj?.changeTorch()
        
        if isFlashOn {
            sender.setImage(#imageLiteral(resourceName: "btn_enableTorch_w"), for: .normal)
        }else {
            sender.setImage(#imageLiteral(resourceName: "btn_unenableTorch_w"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "扫码用车"
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor.white
        
        var style = LBXScanViewStyle()
        style.anmiationStyle = .NetGrid
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_full_net")
        
        scanStyle = style
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubview(toFront: panelView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        navigationController?.navigationBar.barStyle = .default
//    }

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
