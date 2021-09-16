//
//  StartViewController.swift
//  RunningX
//
//  Created by Eduarda Soares Serpa Camboim on 16/09/21.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = UIImage(named: "bgGame3")
        backgroundImage.contentMode = .scaleAspectFill
            self.view.insertSubview(backgroundImage, at: 0)

        
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
    }


}
