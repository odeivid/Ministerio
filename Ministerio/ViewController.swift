//
//  ViewController.swift
//  Ministerio
//
//  Created by DEIVID LOUREIRO on 13/12/16.
//  Copyright © 2016 DEIVID LOUREIRO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK - ACTIONS
    @IBAction func abrirSiteJW(_ sender: Any) {
        if let siteURL = NSURL(string: "http://www.jw.org") {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(siteURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(siteURL as URL)
            }
        }
    }
    
    @IBAction func abrirAppJW(_ sender: Any) {
        
        if let appURL = URL(string: "jwlibrary://"){
            
            if UIApplication.shared.canOpenURL(appURL){
            
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            }
        }else{
         
            if let siteURL = NSURL(string: "itms://itunes.apple.com/us/app/jw-library/id672417831?ls=1&mt=8") {
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(siteURL as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(siteURL as URL)
                }
            }
        }
    }
    
}

