//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Aastha Aaryan on 10/11/24.
//

import Foundation


extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
