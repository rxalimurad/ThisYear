//
//  Date.swift
//  ThisYear
//
//  Created by Ali Murad on 16/01/2024.
//

import Foundation

extension Date {
    func toLongString() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy\nhh:mm:ss a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            
            return dateFormatter.string(from: self)
        }
    
}
