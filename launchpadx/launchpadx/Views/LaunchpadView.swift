import SwiftUI

struct LaunchpadView: View {
    @State private var searchText: String = ""
    @State private var isVisible: Bool = false
    
    private var filteredIcons: [AppIcon] {
        if searchText.isEmpty {
            return AppIcon.sampleIcons
        } else {
            return AppIcon.sampleIcons.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        ZStack {
            // 背景
            BlurredBackgroundView()
            
            // 主内容
            VStack {
                // 搜索栏
                SearchBarView(searchText: $searchText)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3).delay(0.1), value: isVisible)
                
                // 应用图标网格
                LaunchpadGridView(columns: 7, spacing: 20, icons: filteredIcons)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3).delay(0.2), value: isVisible)
                    .scaleEffect(isVisible ? 1 : 1.1)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isVisible)
            }
        }
        .onAppear {
            // 显示动画
            withAnimation {
                isVisible = true
            }
        }
    }
}

#Preview {
    LaunchpadView()
} 