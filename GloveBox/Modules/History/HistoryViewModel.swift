import Foundation
import Combine

final class HistoryViewModel: ObservableObject {
    
    private let storage = Storage.instance
    private let imageStorage = ImageStorage.instance
    
    @Published var navPath: [HistoryScreen] = []
    
    @Published private(set) var histories: [History] = []
    
    private(set) var services: [Service] = []
    
    private func loadServices() async  {
        let services = await storage.readObject(as: [Service].self, key: .service) ?? []
        
        await MainActor.run {
            self.services = services
        }
    }
}

extension HistoryViewModel {
    
    func saveHistory(_ history: History) {
        guard let image = history.image else { return }
        
        Task {
            var histories = await storage.readObject(as: [HistoryStorageModel].self, key: .history) ?? []
            
            await imageStorage.save(image, id: history.id)
            
            let historiesStorageModel = HistoryStorageModel(from: history)
            
            if let index = histories.firstIndex(where: { $0.id == history.id }) {
                histories[index] = historiesStorageModel
            } else {
                histories.append(historiesStorageModel)
            }
            
            await self.storage.saveObject(histories, key: .history)
            
            await MainActor.run {
                self.navPath = []
            }
        }
    }
    
    func loadHistories() {
        Task {
            await loadServices()
            
            let historiesStorage = await storage.readObject(as: [HistoryStorageModel].self, key: .history) ?? []
            
            let result = await withTaskGroup(of: History?.self) { group in
                for history in historiesStorage {
                    group.addTask {
                        guard let image = await self.imageStorage.image(for: history.id) else { return nil }
                        var  model = History(from: history, and: image)
                        
                        if let service = self.services.first(where: { $0.id == history.serviceID }) {
                            model.service = service
                        }
                        
                        return model
                    }
                }
                
                var histories: [History?] = []
                
                for await history in group {
                    histories.append(history)
                }
                
                return histories.compactMap { $0 }
            }
            await MainActor.run {
                self.histories = result
            }
        }
    }
    
    func removeHistory(_ history: History) {
        Task {
            var historiesStorage = await storage.readObject(as: [HistoryStorageModel].self, key: .history) ?? []
         
            if let index = historiesStorage.firstIndex(where: { $0.id == history.id }) {
                historiesStorage.remove(at: index)
                await self.imageStorage.delete(history.id)
            }
            
            await self.storage.saveObject(historiesStorage, key: .history)
            
            await MainActor.run {
                self.navPath = []
            }
        }
    }
}
