//
//  RevisitaCadastroViewController.swift
//  Ministerio
//
//  Created by DEIVID LOUREIRO on 15/12/16.
//  Copyright © 2016 DEIVID LOUREIRO. All rights reserved.
//

import UIKit

class RevisitaCadastroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: ACTIONS
    @IBAction func cancelar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
