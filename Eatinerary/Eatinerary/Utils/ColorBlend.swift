//
//  ColorBlend.swift
//  Eatinerary
//
//  Created by David Pittman on 1/10/25.
//

import SwiftUI

extension Color {
    static func blend(from color1: Color, to color2: Color, fraction: Double) -> Color {
        let uiColor1 = UIColor(color1)
        let uiColor2 = UIColor(color2)

        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0

        uiColor1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        uiColor2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        let r = CGFloat(1 - fraction) * r1 + CGFloat(fraction) * r2
        let g = CGFloat(1 - fraction) * g1 + CGFloat(fraction) * g2
        let b = CGFloat(1 - fraction) * b1 + CGFloat(fraction) * b2
        let a = CGFloat(1 - fraction) * a1 + CGFloat(fraction) * a2

        return Color(red: Double(r), green: Double(g), blue: Double(b), opacity: Double(a))
    }
}
