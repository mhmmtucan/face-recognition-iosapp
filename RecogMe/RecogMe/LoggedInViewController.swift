//
//  LoggedInViewController.swift
//  RecogMe
//
//  Created by Muhammet Uçan on 10.10.2017.
//  Copyright © 2017 Muhammet Uçan. All rights reserved.
//

import UIKit

class LoggedInViewController: UIViewController {

    @IBOutlet var username: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.performSegue(withIdentifier: "goBack", sender: self)
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
