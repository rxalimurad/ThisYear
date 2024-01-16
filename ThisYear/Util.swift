//
//  Util.swift
//  ThisYear
//
//  Created by Ali Murad on 16/01/2024.
//

import Foundation

func currentHourPercentageWithSeconds(_ entryDate: Date? = nil) -> Double {
        let calendar = Calendar.current
        let currentDate = entryDate ?? Date()
        
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
func currentMonthPercentageWithSeconds(_ entryDate: Date? = nil) -> Double {
        let calendar = Calendar.current
        let currentDate = entryDate ?? Date()
        
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
func currentWeekPercentageWithSeconds(_ entryDate: Date? = nil) -> Double {
        let calendar = Calendar.current
        let currentDate = entryDate ?? Date()
        
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
func currentYearPercentageWithSeconds(_ entryDate: Date? = nil) -> Double {
        let calendar = Calendar.current
        let currentDate = entryDate ?? Date()
        
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
    
