//
//  Symbol.swift
//  Project 1 Apple
//
//  Created by Rieno on 25/03/25.
//

import SwiftUI

struct checkmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * 0.2, y: rect.height * 0.5))
        path.addLine(to: CGPoint(x: rect.width * 0.4, y: rect.height * 0.7))
        path.addLine(to: CGPoint(x: rect.width * 0.8, y: rect.height * 0.35))
        return path
    }
}
struct circleShape: Shape{
    func path(in rect: CGRect) -> Path {
        return Path(ellipseIn: rect)
    }
}
struct circleBGShape: Shape{
    func path(in rect:CGRect) -> Path{
        return Path(ellipseIn: rect)
    }
}
struct circleBGShape2: Shape{
    func path(in rect:CGRect) -> Path{
        return Path(ellipseIn: rect)
    }
}
