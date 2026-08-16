//
//  EditOptionsView.swift
//  spin
//

import SwiftUI

struct EditOptionsView: View {
    @Bindable var store: WheelStore

    var body: some View {
        List {
            Section {
                ForEach($store.options, editActions: .delete) { $option in
                    TextField("Option", text: $option.label)
                        .deleteDisabled(store.options.count <= WheelStore.minOptions)
                }
            } footer: {
                Text("Swipe left on an option to delete it.")
            }
            Section {
                Button {
                    store.options.append(WheelOption(label: "Option \(store.options.count + 1)"))
                } label: {
                    Label("Add Option", systemImage: "plus")
                }
                .disabled(store.options.count >= WheelStore.maxOptions)

                Button(role: .destructive) {
                    store.options = WheelStore.exampleOptions()
                } label: {
                    Label("Reset to Examples", systemImage: "arrow.counterclockwise")
                }
            }
            Section("Theme") {
                ForEach(WheelTheme.all) { theme in
                    Button {
                        store.themeID = theme.id
                    } label: {
                        HStack {
                            HStack(spacing: -5) {
                                ForEach(0..<4, id: \.self) { i in
                                    Circle()
                                        .fill(theme.slices[i % theme.slices.count])
                                        .frame(width: 14, height: 14)
                                        .overlay(Circle().stroke(theme.background, lineWidth: 1))
                                }
                            }
                            Text(theme.name)
                                .foregroundStyle(.primary)
                            Spacer()
                            if store.themeID == theme.id {
                                Image(systemName: "checkmark")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.tint)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Options")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        EditOptionsView(store: WheelStore())
    }
}
