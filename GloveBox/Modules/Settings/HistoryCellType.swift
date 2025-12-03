enum HistoryCellType: Identifiable, CaseIterable {
    case about
    case notification
    case history
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
            case .about:
                "About the application"
            case .notification:
                "Notification"
            case .history:
                "History"
        }
    }
}
