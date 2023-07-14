//
//  File.swift
//  
//
//  Created by Adam Wienconek on 14/07/2023.
//

import Foundation
import UIKit.UIButton

struct ButtonStorage: Identifiable {
    let id: UUID
    let button: UIButton
    
    init(button: UIButton) {
        self.id = UUID()
        self.button = button
    }
}

extension ButtonStorage: Hashable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
