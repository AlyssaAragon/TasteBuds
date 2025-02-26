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

    @Published var selectedTheme: Theme = .defaultTheme
}

struct AccessibilityView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var textSize: TextSize = .medium

    enum TextSize: String, CaseIterable, Identifiable {
        case small = "Small"
        case medium = "Medium"
        case large = "Large"

        var id: String { self.rawValue }

        var size: CGFloat {
            switch self {
            case .small:
                return 14
            case .medium:
                return 18
            case .large:
                return 24
            }
        }
    }

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
                            .font(.system(size: textSize.size))
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
                        Text("Text Size: \(textSize.rawValue)")
                            .font(.system(size: textSize.size))
                            .foregroundColor(themeManager.selectedTheme.textColor)
                    
                        Picker("Select Text Size", selection: $textSize) {
                            ForEach(TextSize.allCases) { size in
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
