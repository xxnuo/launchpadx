import SwiftUI

struct AppIconView: View {
    let appIcon: AppIcon
    let size: CGFloat
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(appIcon.color)
                    .frame(width: size, height: size)
                
                Image(systemName: appIcon.iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(size * 0.2)
                    .foregroundColor(.white)
                    .frame(width: size, height: size)
            }
            
            Text(appIcon.name)
                .font(.system(size: 12))
                .foregroundColor(.white)
                .lineLimit(1)
        }
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        AppIconView(appIcon: AppIcon.sampleIcons[0], size: 60)
    }
} 