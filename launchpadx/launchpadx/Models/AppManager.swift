import SwiftUI
import AppKit

class AppManager: ObservableObject {
    @Published var appIcons: [AppIcon] = []
    
    init() {
        loadApplications()
    }
    
    func loadApplications() {
        // 获取应用程序文件夹路径
        let applicationsFolders = [
            "/Applications",
            "~/Applications",
            "/System/Applications"
        ]
        
        var allApps: [AppIcon] = []
        
        for folderPath in applicationsFolders {
            let expandedPath = NSString(string: folderPath).expandingTildeInPath
            let fileManager = FileManager.default
            
            guard let appURLs = try? fileManager.contentsOfDirectory(
                at: URL(fileURLWithPath: expandedPath),
                includingPropertiesForKeys: [.isApplicationKey],
                options: [.skipsHiddenFiles]
            ) else { continue }
            
            for appURL in appURLs {
                // 检查是否是应用程序
                if appURL.pathExtension == "app" {
                    let appName = appURL.deletingPathExtension().lastPathComponent
                    
                    // 获取应用图标
                    if let appIcon = getAppIcon(for: appURL) {
                        let icon = AppIcon(
                            name: appName,
                            iconName: "", // 不使用系统图标名称
                            color: .clear, // 不使用背景颜色
                            appURL: appURL,
                            nsImage: appIcon
                        )
                        allApps.append(icon)
                    }
                }
            }
        }
        
        // 按名称排序
        allApps.sort { $0.name.lowercased() < $1.name.lowercased() }
        
        DispatchQueue.main.async {
            self.appIcons = allApps
        }
    }
    
    private func getAppIcon(for appURL: URL) -> NSImage? {
        let workspace = NSWorkspace.shared
        return workspace.icon(forFile: appURL.path)
    }
    
    func launchApplication(at url: URL) {
        NSWorkspace.shared.open(url)
    }
} 