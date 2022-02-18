//
//  SettingsView.swift
//  RGBScreen
//
//  Created by Svetlana Korosteleva on 2/16/22.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsProvider = SettingsProvider.getInstance()
    
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
                Slider(value: $settingsProvider.saturation,
                       in: SettingsProvider.minValue...SettingsProvider.maxValue) {
                    CustomizedText("")
                } minimumValueLabel: {
                    CustomizedText("Low")
                } maximumValueLabel: {
                    CustomizedText("High")
                }
                .padding(.bottom)
                
                CustomizedText("Speed")
                Slider(value: $settingsProvider.speed,
                       in: SettingsProvider.minValue...SettingsProvider.maxValue) {
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
}

struct SettingsView_Previews: PreviewProvider {
    @State static var isPresented = true
    static var previews: some View {
        Group {
            SettingsView(isPresented: $isPresented)
        }
    }
}
