//
//  Scrapbook+CoreDataClass.swift
//  scrapeapp
//
//  Created by automated-fix on 2025-10-21.
//

import Foundation
import CoreData

@objc(Scrapbook)
public class Scrapbook: NSManagedObject {

}

extension Scrapbook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Scrapbook> {
        return NSFetchRequest<Scrapbook>(entityName: "Scrapbook")
    }

    @NSManaged public var bodyContent: Data?
    @NSManaged public var coverImageData: Data?
    @NSManaged public var creationDate: Date?
    @NSManaged public var pageStyle: String?
    @NSManaged public var title: String?

}

extension Scrapbook: Identifiable {}
