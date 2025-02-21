//
//  AccessibilityView.swift
//  TasteBuds
//
//  Created by Ali on 2/18/25.
//

import SwiftUI

struct AccessibilityView: View {
    @State private var selectedTheme: Theme = .defaultTheme
    @State private var textSize: TextSize = .medium

    enum Theme: String, CaseIterable, Identifiable {
        case defaultTheme = "Default"
        case highContrast = "High Contrast"

        var id: String { self.rawValue }

        var backgroundColor: Color {
            switch self {
            case .defaultTheme:
                return .white
            case .highContrast:
                return .black
            }
        }

        var textColor: Color {
            switch self {
            case .defaultTheme:
                return .black
            case .highContrast:
                return .yellow
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
            
            VStack(alignment: .leading, spacing: 20) {

                // Background Theme Picker
                VStack(alignment: .leading) {
                    Text("Background Theme:")
                        .font(.system(size: textSize.size))
                        .foregroundColor(selectedTheme.textColor)
                    Picker("Select Background Theme", selection: $selectedTheme) {
                        ForEach(Theme.allCases) { theme in
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
                        .foregroundColor(selectedTheme.textColor)
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
            .background(selectedTheme.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationTitle("Accessibility Settings")
        }
    }
}

struct AccessibilityView_Previews: PreviewProvider {
    static var previews: some View {
        AccessibilityView()
    }
}


#Preview {
    AccessibilityView()
}
