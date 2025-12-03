import UIKit

struct Document: Identifiable, Hashable {
    let id: UUID
    var image: UIImage?
    var issueDate: Date
    var expirationDate: Date
    var type: String
    var notes: String
    
    var isLock: Bool {
        image == nil || type == "" || notes == ""
    }
    
    init(isPreview: Bool) {
        self.id = UUID()
        self.image = isPreview ? .Images.Splash.splashScreen : nil
        self.issueDate = Date()
        self.expirationDate = Date()
        self.type = isPreview ? "Passport" : ""
        self.notes = isPreview ? "Some notes" : ""
    }
    
    init(from storageModel: DocumentStorageModel, amd image: UIImage) {
        self.id = storageModel.id
        self.image = image
        self.issueDate = storageModel.issueDate
        self.expirationDate = storageModel.expirationDate
        self.type = storageModel.type
        self.notes = storageModel.notes
    }
}
