//
//  UserEntity+CoreDataClass.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import CoreData
import Foundation

@objc(UserEntity)
public class UserEntity: NSManagedObject {
    
    func toMatchUser() -> MatchUser {
        return MatchUser(
            id: self.userID ?? "",
            name: self.name ?? "",
            age: Int(self.age),
            location: self.location ?? "",
            profileImageURL: self.profileImageURL ?? "",
            email: self.email ?? "",
            phone: self.phone ?? "",
            matchStatus: MatchStatus(rawValue: self.matchStatus ?? "pending") ?? .pending
        )
    }
    
    func update(from matchUser: MatchUser) {
        self.userID = matchUser.id
        self.name = matchUser.name
        self.age = Int32(matchUser.age)
        self.location = matchUser.location
        self.profileImageURL = matchUser.profileImageURL
        self.email = matchUser.email
        self.phone = matchUser.phone
        self.matchStatus = matchUser.matchStatus.rawValue
        self.lastUpdated = Date()
    }
    
    static func create(from matchUser: MatchUser, context: NSManagedObjectContext) -> UserEntity {
        let entity = UserEntity(context: context)
        entity.update(from: matchUser)
        return entity
    }
}

extension UserEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }
    
    @NSManaged public var userID: String?
    @NSManaged public var name: String?
    @NSManaged public var age: Int32
    @NSManaged public var location: String?
    @NSManaged public var profileImageURL: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var matchStatus: String?
    @NSManaged public var lastUpdated: Date?
}

extension UserEntity: Identifiable {
    public var id: String {
        return userID ?? UUID().uuidString
    }
}
