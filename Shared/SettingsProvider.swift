//
//  SettingsProvider.swift
//  RGBScreen
//
//  Created by Svetlana Korosteleva on 2/16/22.
//

import Foundation

class SettingsProvider: ObservableObject {
    enum DoubleSettings: String {
        case saturation
        case speed
        
        func minValue() -> Double {
            switch (self) {
            case .speed:
                return 20
            case .saturation:
                return 20
            }
        }
        
        func maxValue() -> Double {
            switch (self) {
            case .speed:
                return 100
            case .saturation:
                return 100
            }
        }
        
        func defaultValue() -> Double {
            switch (self) {
            case .speed:
                return 100
            case .saturation:
                return 100
            }
        }
        
        func baseValue() -> Double {
            switch (self) {
            case .speed:
                return 100
            case .saturation:
                return 100
            }
        }
        
        fileprivate func key() -> String {
            return "com.heliosxii.RGBScreen." + rawValue

        }
    }
    @Published var doubleSettings: [DoubleSettings: Double] {
        didSet {
            for (key, value) in doubleSettings {
                saveDoubleValue(value, for: key)
            }
        }
    }
    
    static let shared = SettingsProvider()
    
    private init() {
        self.doubleSettings = [
                               .speed: SettingsProvider.getDoubleValue(for: .speed),
                               .saturation: SettingsProvider.getDoubleValue(for: .saturation)
                               ]
    }

    
    private static func getDoubleValue(for setting: DoubleSettings) -> Double {
        let savedValue = UserDefaults.standard.double(forKey: setting.key())
        return (savedValue >= setting.minValue() && savedValue <= setting.maxValue()) ? savedValue : setting.defaultValue()
    }
    
    private func saveDoubleValue(_ value: Double, for setting: DoubleSettings) {
        UserDefaults.standard.set(value, forKey: setting.key())
    }
}

