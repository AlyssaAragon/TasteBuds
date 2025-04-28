//
//  AccessibilityView.swift
//  TasteBuds
//
//  Created by Ali on 2/18/25.
//

import SwiftUI

class ThemeManager: ObservableObject {
    enum Theme: String, CaseIterable, Identifiable {
        case defaultTheme = "Default"
        case highContrast = "High Contrast"

        var id: String { self.rawValue }

        var backgroundView: some View {
            switch self {
            case .defaultTheme:
                return AnyView(Color.clear.customGradientBackground().ignoresSafeArea())
            case .highContrast:
                return AnyView(Color.yellow.ignoresSafeArea())
            }
        }

        var textColor: Color {
            switch self {
            case .defaultTheme:
                return .black
            case .highContrast:
                return .black
            }
        }
    }
    
    enum TextSize: String, CaseIterable, Identifiable {
        case small = "Small"
        case medium = "Medium"
        case large = "Large"

        var id: String { self.rawValue }

        var size: CGFloat {
            switch self {
            case .small: return 14
            case .medium: return 18
            case .large: return 24
            }
        }
    }
    
    @Published var selectedTheme: Theme {
            didSet {
                UserDefaults.standard.set(selectedTheme.rawValue, forKey: "selectedTheme")
            }
        }

    @Published var textSize: TextSize {
        didSet {
            UserDefaults.standard.set(textSize.rawValue, forKey: "textSize")
        }
    }

    init() {
        if let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme"),
           let theme = Theme(rawValue: savedTheme) {
            selectedTheme = theme
        } else {
            selectedTheme = .defaultTheme
        }

        if let savedTextSize = UserDefaults.standard.string(forKey: "textSize"),
           let size = TextSize(rawValue: savedTextSize) {
            textSize = size
        } else {
            textSize = .medium
        }
    }
//    @Published var selectedTheme: Theme = .defaultTheme
}

struct AccessibilityView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        NavigationView {
            ZStack(){
                themeManager.selectedTheme.backgroundView
                VStack() {
                    // Background Theme Picker
                    VStack(alignment: .leading) {
                        Text("Accessibility Settings")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.selectedTheme.textColor)
                            .padding()
                        
                        Text("Background Theme:")
                            .font(.system(size: themeManager.textSize.size))
                            .foregroundColor(themeManager.selectedTheme.textColor)
                        
                        Picker("Select Background Theme", selection: $themeManager.selectedTheme){
                            ForEach(ThemeManager.Theme.allCases) { theme in
                                Text(theme.rawValue).tag(theme)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding()
                    
                    // Text Size Picker
                    VStack(alignment: .leading) {
                        Text("Text Size: \(themeManager.textSize.rawValue)")
                            .font(.system(size: themeManager.textSize.size))
                            .foregroundColor(themeManager.selectedTheme.textColor)

                        Picker("Select Text Size", selection: $themeManager.textSize) {
                            ForEach(ThemeManager.TextSize.allCases) { size in
                                Text(size.rawValue).tag(size)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding()
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct AccessibilityView_Previews: PreviewProvider {
    static var previews: some View {
        AccessibilityView()
            .environmentObject(ThemeManager())
    }
}


#Preview {
    AccessibilityView()
        .environmentObject(ThemeManager())
}
