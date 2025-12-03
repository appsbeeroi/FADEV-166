import SwiftUI

struct AppTabView: View {
    
    @State private var currentTab: AppTab = .maintance
    @State private var hasTabbar = true
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $currentTab) {
                MaintanceView(hasTabbar: $hasTabbar)
                    .tag(AppTab.maintance)
                
                HistoryView(hasTabbar: $hasTabbar)
                    .tag(AppTab.history)
                
                DocumentsView(hasTabbar: $hasTabbar)
                    .tag(AppTab.documents)
                
                SettingsView(hasTabbar: $hasTabbar)
                    .tag(AppTab.settings)
            }
            
            VStack {
                HStack {
                    ForEach(AppTab.allCases) { tab in
                        Button {
                            currentTab = tab
                        } label: {
                            ZStack {
                                if currentTab == tab {
                                    Color.white
                                        .cornerRadius(20)
                                }
                                
                                Image(tab.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 73, height: 73)
                            }
                            .frame(width: 75, height: 75)
                        }
                    }
                }
                .opacity(hasTabbar ? 1 : 0)
                .animation(.default, value: hasTabbar)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

#Preview {
    AppTabView()
}
