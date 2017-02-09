//
//  BaseViewController.swift
//  OpenCVToy
//
//  Created by Jingwei Wu on 08/02/2017.
//  Copyright © 2017 jingweiwu. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var animatedOnNavigationBar = true
    var viewTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = viewTitle
        
        let tempNavigationBackButton = UIBarButtonItem()
        tempNavigationBackButton.title = self.viewTitle
        self.navigationItem.backBarButtonItem = tempNavigationBackButton

        
        guard let navigationController = navigationController else {
            return
        }
        
//        navigationController.navigationBar.backgroundColor = nil
//        //        navigationController.navigationBar.barTintColor = UIColor.wisTintColor()
//        navigationController.navigationBar.isTranslucent = true
//        navigationController.navigationBar.shadowImage = nil
//        navigationController.navigationBar.barStyle = UIBarStyle.default
//        navigationController.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
//        //        backBarButtonItem.title = ""
//        //        navigationController.navigationItem.backBarButtonItem = backBarButtonItem
//        
//        let textAttributes = [
//            NSForegroundColorAttributeName: UIColor.white,
//            // NSForegroundColorAttributeName: UIColor.whiteColor(),
//            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)
//        ]
//        
//        navigationController.navigationBar.titleTextAttributes = textAttributes
//        navigationController.navigationBar.tintColor = nil
//        
//        if navigationController.isNavigationBarHidden {
//            navigationController.setNavigationBarHidden(false, animated: animatedOnNavigationBar)
//        }
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
