import SwiftUI


    func getBusPercentage(_ value: CGFloat) -> Int {
        let minDistance: CGFloat = 1000 // 1.0 km in meters
        let maxDistance: CGFloat = 10 // 0.01 km in meters
        let progress = 1 - (value - maxDistance) / (minDistance - maxDistance)
        let roundedProgress = max(0, min(1, progress))
        let percentage = Int(roundedProgress * 100)
        return percentage
    }
