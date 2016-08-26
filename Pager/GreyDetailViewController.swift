//
//  GreyDetailViewController.swift
//  Pager
//
//  Created by Antonio Alves on 8/16/16.
//  Copyright © 2016 Cheesecake. All rights reserved.
//

import UIKit

class GreyDetailViewController: UIViewController {
    
    @IBOutlet weak var detailText: UILabel! {
        didSet {
            detailText.text = text
        }
    }
    
    var text: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
