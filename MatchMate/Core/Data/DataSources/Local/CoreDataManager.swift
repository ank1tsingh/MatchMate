//
//  CoreDataManager.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import CoreData
import Foundation
import Combine

protocol CoreDataManagerProtocol {
    func saveUser(_ user: MatchUser) -> AnyPublisher<Void, Error>
    func fetchUsers() -> AnyPublisher<[MatchUser], Error>
    func updateUserMatchStatus(_ userID: String, status: MatchStatus) -> AnyPublisher<Void, Error>
    func deleteUser(_ userID: String) -> AnyPublisher<Void, Error>
    func clearAllUsers() -> AnyPublisher<Void, Error>
}

class CoreDataManager: CoreDataManagerProtocol {
    private let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
    }
    
    private var context: NSManagedObjectContext {
        return persistenceController.container.viewContext
    }
    
    func saveUser(_ user: MatchUser) -> AnyPublisher<Void, Error> {
        return Future { promise in
            self.context.perform {
                do {
                    let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "userID == %@", user.id)
                    
                    let existingUsers = try self.context.fetch(fetchRequest)
                    
                    if let existingUser = existingUsers.first {
                        existingUser.update(from: user)
                    } else {
                        _ = UserEntity.create(from: user, context: self.context)
                    }
                    
                    try self.context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchUsers() -> AnyPublisher<[MatchUser], Error> {
        return Future { promise in
            self.context.perform {
                do {
                    let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastUpdated", ascending: false)]
                    
                    let userEntities = try self.context.fetch(fetchRequest)
                    let matchUsers = userEntities.map { $0.toMatchUser() }
                    promise(.success(matchUsers))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateUserMatchStatus(_ userID: String, status: MatchStatus) -> AnyPublisher<Void, Error> {
        return Future { promise in
            self.context.perform {
                do {
                    let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
                    
                    if let userEntity = try self.context.fetch(fetchRequest).first {
                        userEntity.matchStatus = status.rawValue
                        userEntity.lastUpdated = Date()
                        try self.context.save()
                        promise(.success(()))
                    } else {
                        promise(.failure(CoreDataError.userNotFound))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteUser(_ userID: String) -> AnyPublisher<Void, Error> {
        return Future { promise in
            self.context.perform {
                do {
                    let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
                    
                    if let userEntity = try self.context.fetch(fetchRequest).first {
                        self.context.delete(userEntity)
                        try self.context.save()
                        promise(.success(()))
                    } else {
                        promise(.failure(CoreDataError.userNotFound))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func clearAllUsers() -> AnyPublisher<Void, Error> {
        return Future { promise in
            self.context.perform {
                do {
                    let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                    let users = try self.context.fetch(fetchRequest)
                    
                    for user in users {
                        self.context.delete(user)
                    }
                    
                    try self.context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - CoreDataError.swift
enum CoreDataError: Error {
    case userNotFound
    case saveFailed
    case fetchFailed
    
    var localizedDescription: String {
        switch self {
        case .userNotFound:
            return "User not found in database"
        case .saveFailed:
            return "Failed to save data"
        case .fetchFailed:
            return "Failed to fetch data"
        }
    }
}
