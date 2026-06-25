//
//  WebViewController.swift
//  Campa
//
//  Created by myfy on 2026/6/25.
//

import UIKit

enum LinkType: Int {
     case userAgreement = 0
     case privacyPolicy
}

class WebViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navType = .back
    }
}
