//
//  Text_EXT.swift
//  Weaver_Widget_Demo
//
//  Created by Dermot Boyle on 8/5/23.
//

import Foundation
import SwiftUI


extension Text {
    func tertiaryText() -> some View {
        self
            .font(.system(size: 12))
            .foregroundColor(Color("TertiaryText"))
    }
    
    func secondaryText() -> some View {
        self
            .font(.system(size: 14))
            .foregroundColor(Color.white)
    }
}
