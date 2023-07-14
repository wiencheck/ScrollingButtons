//
//  ViewController.swift
//  ScrollingButtons
//
//  Created by Adam Wienconek on 11/07/2023.
//

import UIKit
import ScrollingButtons

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollingButtons: ScrollingButtonsView!
    
    let titles = ["Close", "Stop", "Start", "Hol up!", "4/20", "Cool beans"]

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        for title in titles {
            var configuration: UIButton.Configuration = .bordered()
            configuration.title = title
            configuration.cornerStyle = .capsule
            configuration.baseForegroundColor = .label
            configuration.baseBackgroundColor = .systemPink.withAlphaComponent(0.8)
            configuration.background.strokeColor = .systemPink
            let button = UIButton(
                configuration: configuration,
                primaryAction: UIAction() { [weak scrollingButtons] in
                    if title == "Stop" {
                        scrollingButtons?.layoutConfiguration.interItemSpacing *= 2
                    }
                    else {
                        let sender = ($0.sender as! UIButton)
                        scrollingButtons?.removeButton(sender)
                    }
                }
            )
            
            scrollingButtons.addButton(button)
        }
    }


}
