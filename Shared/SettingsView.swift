//
//  SettingsView.swift
//  RGBScreen
//
//  Created by Svetlana Korosteleva on 2/16/22.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsProvider = SettingsProvider.shared
    
    @Binding var isPresented: Bool
    
    private let textColor = Color.white.opacity(0.8)
    
    init(isPresented: Binding<Bool>){
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(textColor)]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(textColor)]
        self._isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                CustomizedText("Saturation")
                Slider(value: binding(for: .saturation),
                       in: range(for: .saturation)) {
                    CustomizedText("")
                } minimumValueLabel: {
                    CustomizedText("Low")
                } maximumValueLabel: {
                    CustomizedText("High")
                }
                .padding(.bottom)
                
                CustomizedText("Speed")
                Slider(value: binding(for: .speed),
                       in: range(for: .speed)) {
                    CustomizedText("")
                } minimumValueLabel: {
                    CustomizedText("Slow")
                } maximumValueLabel: {
                    CustomizedText("Fast")
                }
                Spacer()

            }
            .padding()
            .navigationTitle("Settings")
            .toolbar {
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark")
                }
            }
            .background(.gray.opacity(0.8))
            .tint(.white)
        }
    }
    
    private func CustomizedText(_ text: String) -> Text {
        return Text(text)
            .foregroundColor(textColor)
    }
    
    private func binding(for key: SettingsProvider.DoubleSettings) -> Binding<Double> {
        return Binding { settingsProvider.doubleSettings[key, default: key.defaultValue()] }
                set: { settingsProvider.doubleSettings[key] = $0 }

    }
    
    private func range(for key: SettingsProvider.DoubleSettings) -> ClosedRange<Double> {
        return key.minValue()...key.maxValue()
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var isPresented = true
    static var previews: some View {
        Group {
            SettingsView(isPresented: $isPresented)
        }
    }
}
