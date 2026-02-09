import SwiftUI

struct PixTimerView: View {
    let expiresAt: Date
    var onExpired: (() -> Void)?

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let remaining = expiresAt.timeIntervalSince(context.date)
            let isExpired = remaining <= 0

            VStack(spacing: AppTheme.smallSpacing) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 6)
                        .frame(width: 100, height: 100)

                    Circle()
                        .trim(from: 0, to: isExpired ? 0 : CGFloat(min(remaining / (24 * 3600), 1)))
                        .stroke(
                            isExpired ? Color.appDanger : Color.appPrimary,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: remaining)

                    VStack(spacing: 0) {
                        Image(systemName: isExpired ? "clock.badge.xmark" : "clock")
                            .font(.title3)
                            .foregroundStyle(isExpired ? .appDanger : .appPrimary)
                        Text(isExpired ? "Expirado" : formatTime(remaining))
                            .font(.system(.caption, design: .monospaced).bold())
                            .foregroundStyle(isExpired ? .appDanger : .primary)
                    }
                }

                Text(isExpired ? "PIX expirado" : "Tempo restante")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .onChange(of: isExpired) { _, expired in
                if expired { onExpired?() }
            }
        }
    }

    private func formatTime(_ interval: TimeInterval) -> String {
        let totalSeconds = Int(max(interval, 0))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
