import SwiftUI

struct ContentView: View {
    @State private var selectedIndex = 0
    @State private var showTabView = false      // ← when true, we show the TabView
    @EnvironmentObject var dateModel: DateModel

    var body: some View {
        ZStack {
            // 1) TabView, mostrata solo se showTabView == true
            if showTabView {
                TabView(selection: $selectedIndex) {
                    Group{
                        ClockView()
                            .tabItem {
                                Image(systemName: selectedIndex == 0 ? "clock.fill" : "clock")
                                Text("Clock")
                            }
                            .tag(0)
                        
                        CalendarView()
                            .tabItem {
                                Image(systemName: "calendar")
                                Text("Calendar")
                            }
                            .tag(1)
                        
                        AdminView()
                            .tabItem {
                                Image(systemName: selectedIndex == 2 ? "person.crop.circle.fill" : "person.crop.circle")
                                Text("Profile")
                            }
                            .tag(2)
                    }.toolbarBackground(Color("TabBarBackground"), for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                }
                .accentColor(Color("AccentColorTabBar"))
                .onChange(of: selectedIndex) {
                    dateModel.viewTaskInfo = false
                }
            }

            // 2) Animazione full‑screen finché showTabView == false
            if !showTabView {
                ClockAnimationView(showMainView: $showTabView)
                    .transition(.opacity)
            }
        }
        // facoltativo: animazione della transizione
        .animation(.easeInOut(duration: 0.3), value: showTabView)
    }
}

#Preview {
    ContentView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel())
}
