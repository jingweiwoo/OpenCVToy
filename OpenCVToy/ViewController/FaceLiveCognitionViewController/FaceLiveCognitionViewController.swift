//
//  FaceLiveCognitionViewController.swift
//  OpenCVToy
//
//  Created by Jingwei Wu on 08/02/2017.
//  Copyright © 2017 jingweiwu. All rights reserved.
//

import UIKit

class FaceLiveCognitionViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewTitle = NSLocalizedString("Face Live Cognition", comment: "")
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
