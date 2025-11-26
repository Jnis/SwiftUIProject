//
//  DemoScreenView.swift
//  Demo
//
//  Created by Yanis Plumit on 24.11.2025.
//

import SwiftUI

struct DemoScreenView: View {
    @EnvironmentObject var modalNavigation: AppModalNavigationViewModel
    @EnvironmentObject var stackNavigation: AppStackNavigationViewModel
    
    let value: String
    
    var body: some View {
        ScrollView {
            Text("Path:").font(.title2).bold()
                
            Text(value)
            
            Divider()
                .padding()
            
            Text("Modal").font(.title2).bold()
            
            HStack {
                Button("show modal", action: {
                    modalNavigation.show(modalScreen: .demoScreen(value: value + "/modal"))
                })
                
                Button("show sheet", action: {
                    modalNavigation.show(sheetScreen: .demoScreen(value: value + "/sheet"))
                })
                
                Button("dismiss", action: {
                    modalNavigation.modalDismiss?()
                })
                .buttonStyle(.bordered)
            }
            
            Divider()
                .padding()
            
            Text("Stack").font(.title2).bold()
            
            HStack {
                Button("pop", action: {
                    stackNavigation.pop()
                })
                
                Button("pop to root", action: {
                    stackNavigation.popToRoot()
                })
            }
            .buttonStyle(.bordered)
            
            Button("push demoScreen", action: {
                stackNavigation.push(.demoScreen(value: value + "/push"))
            })
            
            Button("push +asyncStreamScreen", action: {
                stackNavigation.push(.asyncStreamScreen(value: value + "/asyncStream"))
            })
            
            Button("push +combineScreen", action: {
                stackNavigation.push(.combineScreen(value: value + "/combine"))
            })
            
            Button("push anyScreen", action: {
                stackNavigation.push(.anyScreen(screen: .create(
                    Text("Any screen")
                )))
            })
            
            Divider()
                .padding()
            
            DemoNotificationsView()
        }
        .buttonStyle(.borderedProminent)
        .navigationTitle("Demo")
    }
}

#Preview {
    AppModalNavigationView {
        AppStackNavigationView {
            DemoScreenView(value: "Preview")
        }
    }
}

