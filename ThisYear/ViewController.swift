//
//  ViewController.swift
//  ThisYear
//
//  Created by Ali Murad on 16/01/2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var hourProgress: ProgressWidget!
    @IBOutlet var weekProgress: ProgressWidget!
    @IBOutlet var monthProgress: ProgressWidget!
    @IBOutlet var yearProgress: ProgressWidget!
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = Date().toLongString()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateDate), userInfo: nil, repeats: true)

    }
    
    @objc func updateDate() {
        dateLabel.text = Date().toLongString()
        hourProgress.percentage += 2.0
        weekProgress.percentage += 3.0
        monthProgress.percentage += 4.0
        yearProgress.percentage += 5.0
       }
}

