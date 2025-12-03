import Foundation

struct DocumentStorageModel: Codable {
    let id: UUID
    let issueDate: Date
    let expirationDate: Date
    let type: String
    let notes: String
    
    init(from model: Document) {
        self.id = model.id
        self.issueDate = model.issueDate
        self.expirationDate = model.expirationDate
        self.type = model.type
        self.notes = model.notes
    }
}
