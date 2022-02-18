//
//  SettingsProvider.swift
//  RGBScreen
//
//  Created by Svetlana Korosteleva on 2/16/22.
//

import Foundation

class SettingsProvider: ObservableObject {
    @Published var speed: Double {
        didSet {
            saveDoubleValue(speed, for: .speed)
        }
    }
    @Published var saturation: Double {
        didSet {
            saveDoubleValue(saturation, for: .saturation)
        }
    }
    
    static func getInstance() -> SettingsProvider {
        if let instance = _instance {
            return instance
        }
        
        let instance = SettingsProvider()
        _instance = instance
        return instance
    }
    
    private static var _instance: SettingsProvider?
    
    private init() {
        self.speed = SettingsProvider.getDoubleValue(for: .speed)
        self.saturation = SettingsProvider.getDoubleValue(for: .saturation)
    }
    
    enum DoubleSettings: String {
        case saturation
        case speed
        
        func key() -> String {
            return "com.heliosxii.RGBScreen." + rawValue

        }
    }
    
    static let minValue: Double = 20.0
    static let maxValue: Double = 100.0
    private static let defaultValue: Double = 100.0
    
    private static func getDoubleValue(for setting: DoubleSettings) -> Double {
        let savedValue = UserDefaults.standard.double(forKey: setting.key())
        return (savedValue >= minValue) ? savedValue : defaultValue
    }
    
    private func saveDoubleValue(_ value: Double, for setting: DoubleSettings) {
        UserDefaults.standard.set(value, forKey: setting.key())
    }
}

