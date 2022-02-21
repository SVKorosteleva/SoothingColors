//
//  ContentView.swift
//  Shared
//
//  Created by Svetlana Korosteleva on 2/10/22.
//

import SwiftUI
import Combine

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var currentHue: Double = 0.0
    @State var settingsPresented = false
    
    private static let colorStep = 0.001
    private static let timeStep: TimeInterval = 0.01
    
    @ObservedObject private static var settingsProvider = SettingsProvider.shared
    
    @State private var timer = colorChangeTimer()
    
    var body: some View {
        NavigationView {
            Color(hue: currentHue,
                  saturation: ContentView.normalizedValueOrDefault(for: .saturation),
                  brightness: 1.0)
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
        .onChange(of: scenePhase) { newValue in
            switch(newValue) {
            case .background, .inactive:
                timer.upstream.connect().cancel()
            case .active:
                timer = ContentView.colorChangeTimer()
            @unknown default:
                fatalError()
            }
        }
        .onChange(of: ContentView.settingsProvider.doubleSettings[.speed]) { _ in
            timer = ContentView.colorChangeTimer()
        }
    }
    
    private func shift(hue: Double) -> Double {
        let newHue = hue + ContentView.colorStep
        return newHue > 1.0 ? 0.0 : newHue
    }
    
    private static func colorChangeTimer() -> Publishers.Autoconnect<Timer.TimerPublisher> {
        return Timer
            .publish(every: ContentView.timeStep / normalizedValueOrDefault(for: .speed),
                     on: .main,
                     in: .common)
            .autoconnect()
    }
    
    private static func normalizedValueOrDefault(for key: SettingsProvider.DoubleSettings) -> Double {
        return (ContentView.settingsProvider.doubleSettings[key] ?? key.defaultValue()) / key.baseValue()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
