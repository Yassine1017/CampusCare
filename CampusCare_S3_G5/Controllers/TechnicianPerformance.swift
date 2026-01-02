import Foundation

// Renamed to TechData to avoid conflict with Storyboard names
struct TechData {
    let name: String
    let averageRating: Double
    let totalCompleted: Int
    let avgResolutionTime: String
    let specialty: String
    
    init(name: String, averageRating: Double, totalCompleted: Int, avgResolutionTime: String, specialty: String) {
        self.name = name
        self.averageRating = averageRating
        self.totalCompleted = totalCompleted
        self.avgResolutionTime = avgResolutionTime
        self.specialty = specialty
    }
}
