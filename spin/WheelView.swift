//
//  WheelView.swift
//  spin
//

import SwiftUI

struct WheelView: View {
    let options: [WheelOption]
    let rotation: Double
    let showsHint: Bool

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let radius = size / 2
            ZStack {
                slices(radius: radius)
                    .rotationEffect(.degrees(rotation))
                Circle()
                    .strokeBorder(.white.opacity(0.25), lineWidth: 2)
                hub(radius: radius)
                pointer(radius: radius)
            }
            .frame(width: size, height: size)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func slices(radius: CGFloat) -> some View {
        let sliceDegrees = 360.0 / Double(max(options.count, 1))
        return ZStack {
            ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                let start = -90 + Double(index) * sliceDegrees
                WheelSlice(startDegrees: start, endDegrees: start + sliceDegrees)
                    .fill(WheelPalette.color(at: index, of: options.count))
                WheelSlice(startDegrees: start, endDegrees: start + sliceDegrees)
                    .stroke(.black.opacity(0.35), lineWidth: 1)
                sliceLabel(option.label, midDegrees: start + sliceDegrees / 2, radius: radius)
            }
        }
    }

    private func sliceLabel(_ text: String, midDegrees: Double, radius: CGFloat) -> some View {
        let hubRadius = radius * 0.21
        let distance = hubRadius + (radius - hubRadius) * 0.52
        let normalized = (midDegrees.truncatingRemainder(dividingBy: 360) + 360)
            .truncatingRemainder(dividingBy: 360)
        // Labels on the left half would render upside down; flip them to read inward.
        let flipped = normalized > 90 && normalized < 270
        return Text(text)
            .font(.system(size: max(9, radius * 0.12), weight: .semibold, design: .rounded))
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .shadow(color: .black.opacity(0.5), radius: 1)
            .frame(width: (radius - hubRadius) * 0.88)
            .rotationEffect(.degrees(flipped ? 180 : 0))
            .offset(x: distance)
            .rotationEffect(.degrees(midDegrees))
    }

    private func hub(radius: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(.black)
                .overlay(Circle().strokeBorder(.white.opacity(0.4), lineWidth: 1.5))
            if showsHint {
                Text("TAP")
                    .font(.system(size: radius * 0.14, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: radius * 0.42, height: radius * 0.42)
    }

    private func pointer(radius: CGFloat) -> some View {
        PointerShape()
            .fill(.white)
            .overlay(PointerShape().stroke(.black.opacity(0.5), lineWidth: 1))
            .frame(width: radius * 0.16, height: radius * 0.2)
            .shadow(color: .black.opacity(0.4), radius: 1, y: 1)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct WheelSlice: Shape {
    let startDegrees: Double
    let endDegrees: Double

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()
        path.move(to: center)
        path.addArc(center: center,
                    radius: min(rect.width, rect.height) / 2,
                    startAngle: .degrees(startDegrees),
                    endAngle: .degrees(endDegrees),
                    clockwise: false)
        path.closeSubpath()
        return path
    }
}

struct PointerShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

enum WheelPalette {
    static let colors: [Color] = [
        Color(red: 0.93, green: 0.27, blue: 0.28),
        Color(red: 0.98, green: 0.57, blue: 0.13),
        Color(red: 0.99, green: 0.79, blue: 0.19),
        Color(red: 0.28, green: 0.73, blue: 0.38),
        Color(red: 0.18, green: 0.66, blue: 0.72),
        Color(red: 0.24, green: 0.48, blue: 0.90),
        Color(red: 0.56, green: 0.35, blue: 0.86),
        Color(red: 0.90, green: 0.32, blue: 0.61),
    ]

    static func color(at index: Int, of count: Int) -> Color {
        // Keep the last slice from matching the first where the wheel wraps around.
        if count > 1, index == count - 1, index % colors.count == 0 {
            return colors[colors.count / 2]
        }
        return colors[index % colors.count]
    }
}

#Preview {
    WheelView(options: WheelStore.exampleOptions(), rotation: 0, showsHint: true)
}
