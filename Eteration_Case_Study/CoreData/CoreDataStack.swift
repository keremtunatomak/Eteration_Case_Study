//
//  CoreDataStack.swift
//  Eteration_Case_Study
//
//  Created by Kerem Tuna Tomak on 7.07.2025.
//

import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "ProductData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData yüklenemedi: \(error.localizedDescription)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return container.viewContext
    }
}
