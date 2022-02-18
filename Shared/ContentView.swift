//
//  ContentView.swift
//  Shared
//
//  Created by Svetlana Korosteleva on 2/10/22.
//

import SwiftUI

struct ContentView: View {
    @State var currentHue: Double = 0.0
    @State var settingsPresented = false
    
    static let colorStep = 0.001
    static let timeStep: TimeInterval = 0.01
    static let baseValue = 100.0
    
    @ObservedObject static var settingsProvider = SettingsProvider.getInstance()
    
    let timer = Timer
        .publish(every: timeStep * ContentView.baseValue / settingsProvider.speed,
                 on: .main,
                 in: .common)
        .autoconnect()
    
    var body: some View {
        NavigationView {
            Color(hue: currentHue,
                  saturation: ContentView.settingsProvider.saturation / ContentView.baseValue,
                  brightness: 100.0 / ContentView.baseValue)
                .edgesIgnoringSafeArea(.all)
                .onReceive(timer) { _ in
                    currentHue = shift(hue: currentHue)
                }
                .toolbar {
                    Button {
                        settingsPresented.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .sheet(isPresented: $settingsPresented) {
                        SettingsView(isPresented: $settingsPresented)
                    }
                }
                .tint(.white)
        }
        .navigationViewStyle(.stack)
        
    }
    
    func shift(hue: Double) -> Double {
        let newHue = hue + ContentView.colorStep
        return newHue > 1.0 ? 0.0 : newHue
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
