//
//  Date + extension.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 02.09.2023.
//

import Foundation

extension Date {
    func strFormatDate() -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMMM yyyy, HH:mm"
        outputFormatter.locale = Locale(identifier: "en_US") // Встановлюємо локаль для англійської мови

        return outputFormatter.string(from: self)
    }
}
