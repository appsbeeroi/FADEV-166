import Foundation

struct Service: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var startDate: Date
    var endDate: Date
    var type: ServiceRangeType?
    var milleage: String
    
    var isLock: Bool {
        name == "" || type == nil
    }
    
    init(isPreview: Bool) {
        self.id = UUID()
        self.name = isPreview ? "Oil changing" : ""
        self.startDate = Date()
        self.endDate = Date()
        self.type = isPreview ? .byDate : nil
        self.milleage = isPreview ? "10000" : ""
    }
}
