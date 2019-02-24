//
//  SetupRemoteViewController.swift
//  gdo
//
//  Created by Jerry Yu on 2/24/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import UIKit

class SetupRemoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let environment = Environment()
        let vc = RemoteControlViewController(environment: environment)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
