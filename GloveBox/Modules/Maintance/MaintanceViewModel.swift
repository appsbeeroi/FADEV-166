import Foundation
import Combine

final class MaintanceViewModel: ObservableObject {
    
    private let storage = Storage.instance
    
    @Published var navPath: [MaintanceScreen] = []
    
    @Published private(set) var services: [Service] = []
    
}

extension MaintanceViewModel {
    
    func saveService(_ service: Service) {
        Task {
            var services = await storage.readObject(as: [Service].self, key: .service) ?? []
         
            if let index = services.firstIndex(where: { $0.id == service.id }) {
                services[index] = service
            } else {
                services.append(service)
            }
            
            await self.storage.saveObject(services, key: .service)
            
            await MainActor.run {
                self.navPath = []
            }
        }
    }
    
    func loadServices() {
        Task {
            let services = await storage.readObject(as: [Service].self, key: .service) ?? []
            
            await MainActor.run {
                self.services = services
            }
        }
    }
    
    func removeService(_ service: Service) {
        Task {
            var services = await storage.readObject(as: [Service].self, key: .service) ?? []
         
            if let index = services.firstIndex(where: { $0.id == service.id }) {
                services.remove(at: index)
            }
            
            await self.storage.saveObject(services, key: .service)
            
            await MainActor.run {
                self.navPath = []
            }
        }
    }
}
