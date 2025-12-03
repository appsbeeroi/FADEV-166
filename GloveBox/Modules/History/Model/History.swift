import UIKit

struct History: Identifiable, Hashable {
    let id: UUID
    var image: UIImage?
    var date: Date
    var milliage: String
    var cost: String
    var notes: String
    var service: Service?
    
    var isLock: Bool {
        image == nil || milliage == "" || cost == "" || notes == ""
    }
    
    init(isPreview: Bool) {
        self.id = UUID()
        self.image = isPreview ? .Images.Splash.splashScreen : nil
        self.milliage = isPreview ? "10,000" : ""
        self.cost = isPreview ? "100" : ""
        self.notes = isPreview ? "Test Notes" : ""
        self.date = Date()
        self.service = isPreview ? Service(isPreview: true) : nil
    }
    
    init(from storage: HistoryStorageModel, and image: UIImage) {
        self.id = storage.id
        self.image = image
        self.milliage = storage.milliage
        self.date = storage.date
        self.cost = storage.cost
        self.notes = storage.notes
    }
}
