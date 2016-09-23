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

}
