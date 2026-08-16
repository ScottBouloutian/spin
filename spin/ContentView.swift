//
//  ContentView.swift
//  spin
//
//  Created by Scott Bouloutian on 8/16/26.
//

import SwiftUI

struct ContentView: View {
    @State private var store = WheelStore()
    @State private var rotation = 0.0
    @State private var isSpinning = false
    @State private var result: WheelOption?

    var body: some View {
        NavigationStack {
            wheelScreen
        }
        .preferredColorScheme(.dark)
    }

    private var wheelScreen: some View {
        WheelView(options: store.options,
                  theme: store.theme,
                  rotation: rotation,
                  showsHint: !isSpinning && result == nil)
            .padding(wheelPadding)
            .offset(y: wheelLift)
            .frame(maxWidth: 480, maxHeight: .infinity)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onTapGesture(perform: spin)
            .overlay(alignment: .bottom) {
                if let result {
                    resultBanner(for: result)
                        .padding(.bottom, bannerBottomPadding)
                }
            }
            .background(store.theme.background.ignoresSafeArea())
            .onChange(of: store.options) {
                result = nil
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        EditOptionsView(store: store)
                    } label: {
                        Label("Edit Options", systemImage: "slider.horizontal.3")
                    }
                    .disabled(isSpinning)
                }
            }
            #if os(watchOS)
            .ignoresSafeArea(edges: .bottom)
            #else
            .navigationTitle("Wheel Spin")
            .navigationBarTitleDisplayMode(.inline)
            #endif
    }

    private var wheelPadding: CGFloat {
        #if os(watchOS)
        return 2
        #else
        return 24
        #endif
    }

    private var bannerBottomPadding: CGFloat {
        #if os(watchOS)
        return 6
        #else
        return 0
        #endif
    }

    // Lifts the wheel into the unused gap below the watch's top bar,
    // leaving matching breathing room above the bottom screen edge.
    private var wheelLift: CGFloat {
        #if os(watchOS)
        return -10
        #else
        return 0
        #endif
    }

    private func resultBanner(for option: WheelOption) -> some View {
        Text(option.label.trimmingCharacters(in: .whitespaces).isEmpty ? "—" : option.label)
            .font(.system(.headline, design: .rounded))
            .foregroundStyle(store.theme.background)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(store.theme.rim, in: .capsule)
            .shadow(color: .black.opacity(0.3), radius: 3, y: 1)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private func spin() {
        guard !isSpinning, !store.options.isEmpty else { return }

        // Fairness: the winner is chosen uniformly at random up front, independent
        // of the animation — the wheel is then driven to land exactly on it.
        let winnerIndex = Int.random(in: 0..<store.options.count)
        let winner = store.options[winnerIndex]

        isSpinning = true
        withAnimation(.easeOut(duration: 0.15)) { result = nil }
        Haptics.spinStarted()

        let sliceDegrees = 360.0 / Double(store.options.count)
        // Land on a random point within the winning slice, not always dead center.
        let jitter = Double.random(in: -0.35...0.35) * sliceDegrees
        let pointerTarget = -(Double(winnerIndex) + 0.5) * sliceDegrees - jitter
        var delta = (pointerTarget - rotation).truncatingRemainder(dividingBy: 360)
        if delta < 0 { delta += 360 }
        let fullSpins = Double(Int.random(in: 4...6)) * 360

        withAnimation(.timingCurve(0.12, 0.68, 0.22, 1.0, duration: 3.2)) {
            rotation += fullSpins + delta
        } completion: {
            isSpinning = false
            Haptics.landed()
            withAnimation(.snappy) { result = winner }
        }
    }
}

#Preview {
    ContentView()
}
