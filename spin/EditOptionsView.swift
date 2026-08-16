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
