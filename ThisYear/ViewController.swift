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
    func currentHourPercentageWithSeconds() -> Double {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let currentHour = calendar.component(.hour, from: currentDate)
        let hourStart = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: calendar.component(.month, from: currentDate), day: calendar.component(.day, from: currentDate), hour: currentHour, minute: 0, second: 0))!
        
        let hourEnd = calendar.date(byAdding: DateComponents(hour: 1, second: -1), to: hourStart)!
        
        let currentDateInHour = max(min(currentDate, hourEnd), hourStart)
        let timeIntervalInHour = currentDateInHour.timeIntervalSince(hourStart)
        let timeIntervalInHourInSeconds = Int(timeIntervalInHour)
        
        let secondsInHour = calendar.dateComponents([.second], from: hourStart, to: hourEnd).second!
        
        let percentage = Double(timeIntervalInHourInSeconds) / Double(secondsInHour) * 100.0
        
        return percentage
    }
    func getCurrentHourRange() -> String {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: Date())

        // Calculate the range based on the current hour
        let hourStart = currentHour
        let hourEnd = (currentHour + 1) % 24

        // Format the range string
        let hourRange = String(format: "%02d-%02d", hourStart, hourEnd)
        
        return hourRange
    }
    func currentMonthPercentageWithSeconds() -> Double {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let currentMonth = calendar.component(.month, from: currentDate)
        let monthStart = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: currentMonth, day: 1, hour: 0, minute: 0, second: 0))!
        
        let monthEnd = calendar.date(byAdding: DateComponents(month: 1, second: -1), to: monthStart)!
        
        let currentDateInMonth = max(min(currentDate, monthEnd), monthStart)
        let timeIntervalInMonth = currentDateInMonth.timeIntervalSince(monthStart)
        let timeIntervalInMonthInSeconds = Int(timeIntervalInMonth)
        
        let secondsInMonth = calendar.dateComponents([.second], from: monthStart, to: monthEnd).second!
        
        let percentage = Double(timeIntervalInMonthInSeconds) / Double(secondsInMonth) * 100.0
        return percentage
    }
    func currentWeekPercentageWithSeconds() -> Double {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let currentWeek = calendar.component(.weekOfYear, from: currentDate)
        let weekStart = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentDate), hour: 0, minute: 0, second: 0, weekday: 1, weekOfYear: currentWeek))!
        
        let weekEnd = calendar.date(byAdding: DateComponents(second: -1, weekOfYear: 1), to: weekStart)!
        
        let currentDateInWeek = max(min(currentDate, weekEnd), weekStart)
        let timeIntervalInWeek = currentDateInWeek.timeIntervalSince(weekStart)
        let timeIntervalInWeekInSeconds = Int(timeIntervalInWeek)
        
        let secondsInWeek = calendar.dateComponents([.second], from: weekStart, to: weekEnd).second!
        
        let percentage = Double(timeIntervalInWeekInSeconds) / Double(secondsInWeek) * 100.0
        
        return percentage
    }
    func currentYearPercentageWithSeconds() -> Double {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let currentYear = calendar.component(.year, from: currentDate)
        let yearStart = calendar.date(from: DateComponents(year: currentYear, month: 1, day: 1, hour: 0, minute: 0, second: 0))!
        let yearEnd = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: yearStart)!
        
        let currentDateInYear = max(min(currentDate, yearEnd), yearStart)
        let timeIntervalInYear = currentDateInYear.timeIntervalSince(yearStart)
        let timeIntervalInYearInSeconds = Int(timeIntervalInYear)
        
        let secondsInYear = calendar.dateComponents([.second], from: yearStart, to: yearEnd).second!
        
        let percentage = Double(timeIntervalInYearInSeconds) / Double(secondsInYear) * 100.0
        return percentage
    }
    func getCurrentYear() -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        let currentYear = calendar.component(.year, from: currentDate)
        return currentYear
    }

    func getCurrentMonthFull() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let currentMonth = dateFormatter.string(from: Date())
        return currentMonth
    }

    func getCurrentWeekNumber() -> Int {
        let calendar = Calendar.current
        let currentWeekNumber = calendar.component(.weekOfYear, from: Date())
        return currentWeekNumber
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

        // Share the screenshot
        let activityViewController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)

    }
    
}

