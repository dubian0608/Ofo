//
//  WebViewController.swift
//  ofo
//
//  Created by Zhang, Frank on 10/05/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var url: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView(frame: self.view.frame)
        let request = URLRequest(url: url)
        webView.load(request)
        
        view.addSubview(webView)

        // Do any additional setup after loading the view.
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
