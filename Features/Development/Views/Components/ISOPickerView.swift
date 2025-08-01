//
//  ISOPickerView.swift
//  Film Lab
//
//  Created by Maxim Eliseyev on 12.07.2025.
//

import SwiftUI

struct ISOPickerView: View {
    @Binding var iso: Int
    let onDismiss: () -> Void
    let availableISOs: [Int]
    
    private let allISOs = [50, 100, 125, 200, 250, 400, 500, 800, 1600, 3200, 6400]
    
    var body: some View {
        NavigationStack {
            Group {
                if availableISOs.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "info.circle")
                            .infoIconStyle()
                        
                        Text(LocalizedStringKey("noISOOptionsAvailable"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(LocalizedStringKey("noISOOptionsDescription"))
                            .disabledTextStyle()
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List(allISOs, id: \.self) { isoValue in
                        let isAvailable = availableISOs.contains(isoValue)
                        
                        Button(action: {
                            if isAvailable {
                                iso = isoValue
                                onDismiss()
                            }
                        }) {
                            HStack {
                                Text(String(format: String(localized: "isoLabel"), "\(isoValue)"))
                                    .primaryTextStyle()
                                    .foregroundColor(isAvailable ? .primary : .secondary)
                                
                                Spacer()
                                
                                if iso == isoValue {
                                    Image(systemName: "checkmark")
                                        .checkmarkStyle()
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(!isAvailable)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(LocalizedStringKey("selectISO"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(LocalizedStringKey("cancel")) {
                        onDismiss()
                    }
                }
            }
        }
    }
}

struct ISOPickerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ISOPickerView(
                iso: .constant(400),
                onDismiss: {},
                availableISOs: [100, 200, 400, 800]
            )
            
            ISOPickerView(
                iso: .constant(400),
                onDismiss: {},
                availableISOs: []
            )
        }
    }
} 