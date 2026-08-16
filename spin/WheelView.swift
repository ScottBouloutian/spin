//
//  WheelView.swift
//  spin
//

import SwiftUI

struct WheelView: View {
    let options: [WheelOption]
    let theme: WheelTheme
    let rotation: Double
    let showsHint: Bool

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let radius = size / 2
            ZStack {
                Circle()
                    .fill(theme.rim)
                    .shadow(color: .black.opacity(0.35), radius: radius * 0.04, y: radius * 0.02)
                slices(radius: radius * 0.93)
                    .frame(width: size * 0.93, height: size * 0.93)
                    .rotationEffect(.degrees(rotation))
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
                    .fill(theme.sliceColor(at: index, of: options.count))
                sliceLabel(option.label, midDegrees: start + sliceDegrees / 2, radius: radius)
            }
        }
    }

    private func sliceLabel(_ text: String, midDegrees: Double, radius: CGFloat) -> some View {
        let hubRadius = radius * 0.22
        let distance = hubRadius + (radius - hubRadius) * 0.52
        let normalized = (midDegrees.truncatingRemainder(dividingBy: 360) + 360)
            .truncatingRemainder(dividingBy: 360)
        // Labels on the left half would render upside down; flip them to read inward.
        let flipped = normalized > 90 && normalized < 270
        return Text(text)
            .font(.system(size: max(9, radius * 0.12), weight: .bold, design: .rounded))
            .foregroundStyle(theme.labelColor)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .frame(width: (radius - hubRadius) * 0.88)
            .rotationEffect(.degrees(flipped ? 180 : 0))
            .offset(x: distance)
            .rotationEffect(.degrees(midDegrees))
    }

    private func hub(radius: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(theme.rim)
            Circle()
                .strokeBorder(theme.background, lineWidth: radius * 0.045)
            if showsHint {
                Text("TAP")
                    .font(.system(size: radius * 0.11, weight: .heavy, design: .rounded))
                    .foregroundStyle(theme.background)
            } else {
                Circle()
                    .fill(theme.hubAccent)
                    .frame(width: radius * 0.12, height: radius * 0.12)
            }
        }
        .frame(width: radius * 0.42, height: radius * 0.42)
    }

    private func pointer(radius: CGFloat) -> some View {
        PointerShape()
            .fill(theme.rim)
            .frame(width: radius * 0.18, height: radius * 0.22)
            .shadow(color: .black.opacity(0.35), radius: radius * 0.015, y: radius * 0.01)
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

#Preview {
    WheelView(options: WheelStore.exampleOptions(),
              theme: .classic,
              rotation: 0,
              showsHint: true)
        .background(WheelTheme.classic.background)
}
