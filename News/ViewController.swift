//
//  ViewController.swift
//  News
//
//  Created by Viacheslav Goroshniuk on 9/23/19.
//  Copyright © 2019 Viacheslav Goroshniuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loadNewsButtonTapped(_ sender: Any) {
        let vc = NewsViewController.init(nibName: nil, bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
}

