import UIKit

enum AppTab: Identifiable, CaseIterable {
    case maintance
    case history
    case documents
    case settings
    
    var id: Self {
        self
    }
    
    var icon: ImageResource {
        switch self {
            case .maintance:
                    .Icons.Tab.maintance
            case .history:
                    .Icons.Tab.history
            case .documents:
                    .Icons.Tab.documents
            case .settings:
                    .Icons.Tab.settings
        }
    }
}
