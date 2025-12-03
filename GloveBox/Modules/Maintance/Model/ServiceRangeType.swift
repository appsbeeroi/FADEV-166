import UIKit

enum ServiceRangeType: Identifiable, CaseIterable, Codable, Hashable {
    case byDate
    case byMilleage
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
            case .byDate:
                "By Date"
            case .byMilleage:
                "By Milleage"
        }
    }
    
    var icon: ImageResource {
        switch self {
            case .byDate:
                    .Images.calendar
            case .byMilleage:
                    .Images.milliage
        }
    }
}
