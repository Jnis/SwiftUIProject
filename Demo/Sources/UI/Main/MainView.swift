import SwiftUI

public struct MainView: View {
    @EnvironmentObject var deepLinkHolder: DeepLinkHolder
    @EnvironmentObject var modalNavigation: AppModalNavigationViewModel
    @State var viewModel = MainViewModel()
    
    public init() {}

    public var body: some View {
        TabView(selection: $viewModel.currentTab) {
            ForEach(viewModel.availableTabs) { tab in
                tab.view
                    .tabItem {
                        VStack {
                            tab.image
                            Text(tab.title)
                        }
                    }
                    .tag(tab)
            }
        }
        .environment(viewModel)
        .onChange(of: deepLinkHolder.deepLink) {
            guard let deepLink = deepLinkHolder.deepLink else { return }
            handleDeepLink(deepLink: deepLink)
        }
        .onAppear{
            deepLinkHolder.readyToHandle()
        }
    }
    
    func handleDeepLink(deepLink: DeepLink) {
        switch deepLink {
        case .tabAsyncStream:
            modalNavigation.hideModalScreens()
            viewModel.currentTab = .asyncStreamScreen
        case .tabCombine:
            modalNavigation.hideModalScreens()
            viewModel.currentTab = .combineScreen
        case .tabNavigation:
            modalNavigation.hideModalScreens()
            viewModel.currentTab = .navigationScreen
        case .demoScreenFullScreen(let id):
            modalNavigation.show(modalScreen: .demoScreen(value: id))
        case .demoScreenSheet(let id):
            modalNavigation.show(sheetScreen: .demoScreen(value: id))
        }
    }
}

#Preview {
    MainView()
}
