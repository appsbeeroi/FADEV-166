import Foundation

struct HistoryStorageModel: Codable {
    let id: UUID
    let milliage: String
    let cost: String
    let notes: String
    let date: Date
    let serviceID: UUID
    
    init(from model: History) {
        self.id = model.id
        self.milliage = model.milliage
        self.date = model.date
        self.cost = model.cost
        self.notes = model.notes
        self.serviceID = model.service?.id ?? UUID()
    }
}
