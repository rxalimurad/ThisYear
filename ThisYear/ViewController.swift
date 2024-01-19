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
        yearProgress.subtitle = yearProgress.subtitle.replacingOccurrences(of: "$$$$", with: "\(getCurrentYear())")
        weekProgress.subtitle = weekProgress.subtitle.replacingOccurrences(of: "$$$$", with: "\(getCurrentWeekNumber())")
        hourProgress.subtitle = hourProgress.subtitle.replacingOccurrences(of: "$$$$", with: "\(getCurrentHourRange())")
        monthProgress.subtitle = monthProgress.subtitle.replacingOccurrences(of: "$$$$", with: "\(getCurrentMonthFull())")

    }
    
    @objc func updateDate() {
        dateLabel.text = Date().toLongString()
        hourProgress.percentage = currentHourPercentageWithSeconds()
        weekProgress.percentage = currentWeekPercentageWithSeconds()
        monthProgress.percentage = currentMonthPercentageWithSeconds()
        yearProgress.percentage = currentYearPercentageWithSeconds()
       }
   
    
    @IBAction func save(_ sender: UIButton) {
      
        // Capture the current screen as an image
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, UIScreen.main.scale)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let screenshot = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        UIGraphicsEndImageContext()

        // Save the screenshot to the photo gallery
        UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
        } else {
            print("Image saved successfully to the photo gallery.")
        }
    }
    @IBAction func share(_ sender: UIButton) {
       
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, UIScreen.main.scale)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let screenshot = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        UIGraphicsEndImageContext()

        DispatchQueue.main.async {
            let activityViewController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
            activityViewController.modalTransitionStyle = .flipHorizontal
            self.present(activityViewController, animated: true, completion: nil)
        }


    }
    
}

