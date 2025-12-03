import Foundation
import Combine

final class DocumentViewModel: ObservableObject {
    
    private let storage = Storage.instance
    private let imageStorage = ImageStorage.instance
    
    @Published var navPath: [DocumentsScreen] = []
    
    @Published private(set) var documents: [Document] = []
}

extension DocumentViewModel {
    
    func saveDocument(_ document: Document) {
        guard let image = document.image else { return }
        
        Task {
            var documents = await storage.readObject(as: [DocumentStorageModel].self, key: .document) ?? []
         
            await imageStorage.save(image, id: document.id)
            
            let documentStorageModel = DocumentStorageModel(from: document)
            
            if let index = documents.firstIndex(where: { $0.id == document.id }) {
                documents[index] = documentStorageModel
            } else {
                documents.append(documentStorageModel)
            }
            
            await self.storage.saveObject(documents, key: .document)
            
            await MainActor.run {
                self.navPath = []
            }
        }
    }
    
    func loadDocuments() {
        Task {
            let documentStorage = await storage.readObject(as: [DocumentStorageModel].self, key: .document) ?? []
            
            let result = await withTaskGroup(of: Document?.self) { group in
                for document in documentStorage {
                    group.addTask {
                        guard let image = await self.imageStorage.image(for: document.id) else { return nil }
                        let model = Document(from: document, amd: image)
                        
                        return model
                    }
                }
                
                var documents: [Document?] = []
                
                for await document in group {
                    documents.append(document)
                }
                
                return documents.compactMap { $0 }
            }
            await MainActor.run {
                self.documents = result
            }
        }
    }
    
    func removeDocument(_ document: Document) {
        Task {
            var documentStorage = await storage.readObject(as: [DocumentStorageModel].self, key: .document) ?? []
         
            if let index = documentStorage.firstIndex(where: { $0.id == document.id }) {
                documentStorage.remove(at: index)
                await self.imageStorage.delete(document.id)
            }
            
            await self.storage.saveObject(documentStorage, key: .document)
            
            await MainActor.run {
                self.navPath = []
            }
        }
    }
}
