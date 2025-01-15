//
//  String.swift
//  OfflineNotes
//
//  Created by Naveen Raj on 14/01/25.
//
import SwiftUI

extension String {
    /// Converts a date string from one format to another.
    /// - Parameters:
    ///   - inputFormat: The format of the input date string.
    ///   - outputFormat: The desired format for the output date string.
    /// - Returns: A formatted date string, or `nil` if conversion fails.
    func formattedDate(from inputFormat: String, to outputFormat: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // POSIX for consistent parsing
        
        // Convert input string to Date object
        guard let date = inputFormatter.date(from: self) else {
            return nil // Return nil if input string is invalid
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: "en_US")
        
        // Convert Date object to output string
        return outputFormatter.string(from: date)
    }
    
    func generateDynamicFileName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        return "Photo_\(dateFormatter.string(from: Date()))"
    }

}
