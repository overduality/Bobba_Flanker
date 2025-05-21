//
//  CollabSpaceCard.swift
//  Project 1 Apple
//
//  Created by Rieno on 07/05/25.
//

import SwiftUI

struct CollabspaceCard: View {
    @Binding var navigationPath: NavigationPath
    @Binding var collabSpace: CollabSpace
    @Binding var selectedDate: Date

    var geometrySize: CGFloat

    var body: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let timeslotWidth = totalWidth * 0.41
            let infoWidth = totalWidth - timeslotWidth

            HStack(spacing: 0) {
                collabSpaceImageAndInfo()
                    .frame(width: infoWidth)

                timeslotSection()
                    .frame(width: timeslotWidth)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .frame(width: geometrySize * 0.8, height: 410)
    }

    private func collabSpaceImageAndInfo() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(collabSpace.image)
                .resizable()
                .scaledToFill()
                .frame(height: 220)
                .clipped()

            VStack(alignment: .leading, spacing: 12) {
                Text(collabSpace.name)
                    .fontWeight(.semibold)
                    .font(.system(size: 20))

                HStack(alignment: .top) {
                    facilitiesView()
                    Spacer()
                    capacityView()
                    Spacer()
                }
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }

    private func facilitiesView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Facilities")
                .font(.system(size:12))
                .foregroundColor(Color("GreyFilter"))

            if collabSpace.tvAvailable {
                facilityItem(icon: "tv", label: "Apple TV")
            }
            if collabSpace.wallWhiteBoard {
                facilityItem(icon: "pencil.and.outline", label: "Whiteboard Wall")
            }
            if collabSpace.tableWhiteBoard {
                facilityItem(icon: "pencil.line", label: "Table Whiteboard")
            }
            if collabSpace.sofa {
                facilityItem(icon: "sofa.fill", label: "Sofa")
            }
            if collabSpace.focusArea {
                facilityItem(icon: "target", label: "Focus Area")
            }
        }
    }

    private func capacityView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Capacity")
                .font(.system(size:12))
                .foregroundColor(.gray)

            HStack(spacing: 8) {
                Image(systemName: "person")
                    .font(.system(size:12))
                Text("\(collabSpace.minCapacity)–\(collabSpace.maxCapacity)")
                    .font(.system(size:12))
            }
        }
    }

    private func timeslotSection() -> some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Select a Time")
                .font(.system(size: 20))
                .fontWeight(.semibold)

            TimeslotManager(
                navigationPath: $navigationPath,
                collabSpace: .constant(collabSpace),
                selectedDate: .constant(selectedDate),
                geometrySize: geometrySize
            )
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RightSideRoundedShape()
                .fill(Color("Green-Light").opacity(0.1))
        )
        .overlay(
            RightSideRoundedShape()
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func facilityItem(icon: String, label: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Color("Green-Dark").opacity(0.7))
            Text(label)
                .font(.system(size: 12))
        }
    }
}

struct TopLeftRoundedShape: Shape {
    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = 12
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addQuadCurve(to: CGPoint(x: rect.minX + radius, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        return path
    }
}
struct RightSideRoundedShape: Shape {
    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = 20
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY)) // Top-left
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY)) // Top edge
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + radius),
                          control: CGPoint(x: rect.maxX, y: rect.minY)) // Top-right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius)) // Right edge
        path.addQuadCurve(to: CGPoint(x: rect.maxX - radius, y: rect.maxY),
                          control: CGPoint(x: rect.maxX, y: rect.maxY)) // Bottom-right corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // Bottom edge
        path.closeSubpath()
        
        return path
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
