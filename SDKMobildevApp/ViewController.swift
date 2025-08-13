//
//  ViewController.swift
//  SDKMobildevApp
//
//  Created by Burak Turhan on 13.08.2025.
//

import UIKit
import mobildevSDK


class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        mobildevSDKClient.shared.trackClick("TestButton")
    }
}
