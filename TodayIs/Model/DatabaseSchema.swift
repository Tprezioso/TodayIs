//
//  DatabaseSchema.swift
//  TodayIs
//
//  Created by Claude on 3/3/26.
//

import Dependencies
import Foundation
import IssueReporting
import GRDB

// MARK: - Dependency Key

private enum DatabaseKey: DependencyKey {
    static let liveValue: DatabaseQueue = {
        fatalError("Database not bootstrapped. Call bootstrapDatabase() first.")
    }()
}

extension DependencyValues {
    var defaultDatabase: DatabaseQueue {
        get { self[DatabaseKey.self] }
        set { self[DatabaseKey.self] = newValue }
    }
}

extension DependencyValues {
    mutating func bootstrapDatabase() throws {
        var configuration = Configuration()
        
        #if DEBUG
        configuration.prepareDatabase { db in
            db.trace { event in
                if case let .statement(statement) = event, !statement.sql.hasPrefix("--") {
                    print("[SQLite] \(statement.sql)")
                }
            }
        }
        #endif
        
        let fileManager = FileManager.default
        let appSupportURL = try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let databaseURL = appSupportURL.appendingPathComponent("holidays.sqlite")
        
        let database = try DatabaseQueue(path: databaseURL.path, configuration: configuration)
        
        var migrator = DatabaseMigrator()
        
        #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        
        // Register migrations
        migrator.registerMigration("v1") { db in
            try db.create(table: "holidays") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("month", .integer).notNull()
                t.column("day", .integer).notNull()
                t.column("url", .text).notNull()
                t.column("image_url", .text)
                t.column("description", .text)
            }
        }
        
        migrator.registerMigration("v2-seed-data") { db in
            try seedInitialHolidays(db)
        }
        
        migrator.registerMigration("v3-comprehensive-holidays") { db in
            try seedComprehensiveHolidays(db)
        }
        
        try migrator.migrate(database)
        defaultDatabase = database
    }
}

// MARK: - Seed Data

private func seedInitialHolidays(_ db: Database) throws {
    let holidays = generateSampleHolidays()
    
    for holiday in holidays {
        try holiday.insert(db)
    }
}

private func seedComprehensiveHolidays(_ db: Database) throws {
    let holidays = generateComprehensiveHolidays()
    
    for holiday in holidays {
        try holiday.insert(db)
    }
}

private func generateComprehensiveHolidays() -> [Holiday] {
    [
        // January
        Holiday(
            name: "New Year's Day",
            month: 1,
            day: 1,
            url: "https://nationaltoday.com/new-years-day/",
            holidayDescription: "Celebrate the beginning of a new year"
        ),
        Holiday(
            name: "National Hangover Day",
            month: 1,
            day: 1,
            url: "https://nationaltoday.com/national-hangover-day/",
            holidayDescription: "Recovery day after New Year's celebrations"
        ),
        Holiday(
            name: "National Science Fiction Day",
            month: 1,
            day: 2,
            url: "https://nationaltoday.com/national-science-fiction-day/",
            holidayDescription: "Celebrate sci-fi literature and media"
        ),
        Holiday(
            name: "National Spaghetti Day",
            month: 1,
            day: 4,
            url: "https://nationaltoday.com/national-spaghetti-day/",
            holidayDescription: "Enjoy a plate of delicious spaghetti"
        ),
        Holiday(
            name: "National Bird Day",
            month: 1,
            day: 5,
            url: "https://nationaltoday.com/national-bird-day/",
            holidayDescription: "Appreciate and protect our feathered friends"
        ),
        Holiday(
            name: "National Thank God It's Monday Day",
            month: 1,
            day: 6,
            url: "https://nationaltoday.com/national-thank-god-its-monday-day/",
            holidayDescription: "Start the week with positivity"
        ),
        Holiday(
            name: "National Bobblehead Day",
            month: 1,
            day: 7,
            url: "https://nationaltoday.com/national-bobblehead-day/",
            holidayDescription: "Celebrate the fun collectible figurines"
        ),
        Holiday(
            name: "National English Toffee Day",
            month: 1,
            day: 8,
            url: "https://nationaltoday.com/national-english-toffee-day/",
            holidayDescription: "Indulge in sweet toffee treats"
        ),
        Holiday(
            name: "National Clean Off Your Desk Day",
            month: 1,
            day: 9,
            url: "https://nationaltoday.com/national-clean-off-your-desk-day/",
            holidayDescription: "Organize your workspace"
        ),
        Holiday(
            name: "National Houseplant Appreciation Day",
            month: 1,
            day: 10,
            url: "https://nationaltoday.com/national-houseplant-appreciation-day/",
            holidayDescription: "Show love to your indoor plants"
        ),
        Holiday(
            name: "National Milk Day",
            month: 1,
            day: 11,
            url: "https://nationaltoday.com/national-milk-day/",
            holidayDescription: "Celebrate dairy's contribution to nutrition"
        ),
        Holiday(
            name: "National Pharmacist Day",
            month: 1,
            day: 12,
            url: "https://nationaltoday.com/national-pharmacist-day/",
            holidayDescription: "Honor pharmacists and their work"
        ),
        Holiday(
            name: "National Sticker Day",
            month: 1,
            day: 13,
            url: "https://nationaltoday.com/national-sticker-day/",
            holidayDescription: "Celebrate the joy of stickers"
        ),
        Holiday(
            name: "National Dress Up Your Pet Day",
            month: 1,
            day: 14,
            url: "https://nationaltoday.com/national-dress-up-your-pet-day/",
            holidayDescription: "Have fun dressing up your pets"
        ),
        Holiday(
            name: "National Hat Day",
            month: 1,
            day: 15,
            url: "https://nationaltoday.com/national-hat-day/",
            holidayDescription: "Wear your favorite hat"
        ),
        Holiday(
            name: "National Nothing Day",
            month: 1,
            day: 16,
            url: "https://nationaltoday.com/national-nothing-day/",
            holidayDescription: "A day to do absolutely nothing"
        ),
        Holiday(
            name: "National Bootlegger's Day",
            month: 1,
            day: 17,
            url: "https://nationaltoday.com/national-bootleggers-day/",
            holidayDescription: "Remember the Prohibition era"
        ),
        Holiday(
            name: "National Thesaurus Day",
            month: 1,
            day: 18,
            url: "https://nationaltoday.com/national-thesaurus-day/",
            holidayDescription: "Expand your vocabulary"
        ),
        Holiday(
            name: "National Popcorn Day",
            month: 1,
            day: 19,
            url: "https://nationaltoday.com/national-popcorn-day/",
            holidayDescription: "Enjoy America's favorite snack"
        ),
        Holiday(
            name: "National Cheese Lovers Day",
            month: 1,
            day: 20,
            url: "https://nationaltoday.com/national-cheese-lovers-day/",
            holidayDescription: "Celebrate all things cheese"
        ),
        
        // February
        Holiday(
            name: "National Get Up Day",
            month: 2,
            day: 1,
            url: "https://nationaltoday.com/national-get-up-day/",
            holidayDescription: "Start fresh and overcome challenges"
        ),
        Holiday(
            name: "Groundhog Day",
            month: 2,
            day: 2,
            url: "https://nationaltoday.com/groundhog-day/",
            holidayDescription: "Will the groundhog see his shadow?"
        ),
        Holiday(
            name: "National Carrot Cake Day",
            month: 2,
            day: 3,
            url: "https://nationaltoday.com/national-carrot-cake-day/",
            holidayDescription: "Enjoy this delicious dessert"
        ),
        Holiday(
            name: "National Homemade Soup Day",
            month: 2,
            day: 4,
            url: "https://nationaltoday.com/national-homemade-soup-day/",
            holidayDescription: "Warm up with homemade soup"
        ),
        Holiday(
            name: "National Weatherperson's Day",
            month: 2,
            day: 5,
            url: "https://nationaltoday.com/national-weatherpersons-day/",
            holidayDescription: "Appreciate weather forecasters"
        ),
        Holiday(
            name: "National Frozen Yogurt Day",
            month: 2,
            day: 6,
            url: "https://nationaltoday.com/national-frozen-yogurt-day/",
            holidayDescription: "Treat yourself to froyo"
        ),
        Holiday(
            name: "National Send a Card to a Friend Day",
            month: 2,
            day: 7,
            url: "https://nationaltoday.com/national-send-a-card-to-a-friend-day/",
            holidayDescription: "Brighten someone's day"
        ),
        Holiday(
            name: "National Kite Flying Day",
            month: 2,
            day: 8,
            url: "https://nationaltoday.com/national-kite-flying-day/",
            holidayDescription: "Fly a kite and enjoy the outdoors"
        ),
        Holiday(
            name: "National Pizza Day",
            month: 2,
            day: 9,
            url: "https://nationaltoday.com/national-pizza-day/",
            holidayDescription: "Celebrate America's favorite food"
        ),
        Holiday(
            name: "National Umbrella Day",
            month: 2,
            day: 10,
            url: "https://nationaltoday.com/national-umbrella-day/",
            holidayDescription: "Appreciate this useful invention"
        ),
        Holiday(
            name: "National Make a Friend Day",
            month: 2,
            day: 11,
            url: "https://nationaltoday.com/national-make-a-friend-day/",
            holidayDescription: "Reach out and make new connections"
        ),
        Holiday(
            name: "National Lost Penny Day",
            month: 2,
            day: 12,
            url: "https://nationaltoday.com/national-lost-penny-day/",
            holidayDescription: "Keep an eye out for loose change"
        ),
        Holiday(
            name: "Galentine's Day",
            month: 2,
            day: 13,
            url: "https://nationaltoday.com/galentines-day/",
            holidayDescription: "Celebrate female friendships"
        ),
        Holiday(
            name: "Valentine's Day",
            month: 2,
            day: 14,
            url: "https://nationaltoday.com/valentines-day/",
            holidayDescription: "Celebrate love and affection"
        ),
        Holiday(
            name: "National Gumdrop Day",
            month: 2,
            day: 15,
            url: "https://nationaltoday.com/national-gumdrop-day/",
            holidayDescription: "Enjoy these colorful candies"
        ),
        Holiday(
            name: "National Almond Day",
            month: 2,
            day: 16,
            url: "https://nationaltoday.com/national-almond-day/",
            holidayDescription: "Celebrate this nutritious nut"
        ),
        Holiday(
            name: "Random Acts of Kindness Day",
            month: 2,
            day: 17,
            url: "https://nationaltoday.com/random-acts-of-kindness-day/",
            holidayDescription: "Spread kindness everywhere"
        ),
        Holiday(
            name: "National Drink Wine Day",
            month: 2,
            day: 18,
            url: "https://nationaltoday.com/national-drink-wine-day/",
            holidayDescription: "Enjoy a glass of wine"
        ),
        Holiday(
            name: "National Chocolate Mint Day",
            month: 2,
            day: 19,
            url: "https://nationaltoday.com/national-chocolate-mint-day/",
            holidayDescription: "Savor this delicious combo"
        ),
        Holiday(
            name: "National Love Your Pet Day",
            month: 2,
            day: 20,
            url: "https://nationaltoday.com/national-love-your-pet-day/",
            holidayDescription: "Show extra love to your pets"
        ),
        
        // March
        Holiday(
            name: "National Peanut Butter Lovers Day",
            month: 3,
            day: 1,
            url: "https://nationaltoday.com/national-peanut-butter-lovers-day/",
            holidayDescription: "Celebrate the beloved spread"
        ),
        Holiday(
            name: "National Read Across America Day",
            month: 3,
            day: 2,
            url: "https://nationaltoday.com/national-read-across-america-day/",
            holidayDescription: "Promote reading and literacy"
        ),
        Holiday(
            name: "National If Pets Had Thumbs Day",
            month: 3,
            day: 3,
            url: "https://nationaltoday.com/national-if-pets-had-thumbs-day/",
            holidayDescription: "Imagine what pets could do"
        ),
        Holiday(
            name: "National Grammar Day",
            month: 3,
            day: 4,
            url: "https://nationaltoday.com/national-grammar-day/",
            holidayDescription: "Celebrate proper language use"
        ),
        Holiday(
            name: "National Cheese Doodle Day",
            month: 3,
            day: 5,
            url: "https://nationaltoday.com/national-cheese-doodle-day/",
            holidayDescription: "Enjoy this cheesy snack"
        ),
        Holiday(
            name: "National Oreo Cookie Day",
            month: 3,
            day: 6,
            url: "https://nationaltoday.com/national-oreo-cookie-day/",
            holidayDescription: "America's favorite cookie"
        ),
        Holiday(
            name: "National Employee Appreciation Day",
            month: 3,
            day: 7,
            url: "https://nationaltoday.com/national-employee-appreciation-day/",
            holidayDescription: "Recognize hard-working employees"
        ),
        Holiday(
            name: "National Proofreading Day",
            month: 3,
            day: 8,
            url: "https://nationaltoday.com/national-proofreading-day/",
            holidayDescription: "Check your work carefully"
        ),
        Holiday(
            name: "National Meatball Day",
            month: 3,
            day: 9,
            url: "https://nationaltoday.com/national-meatball-day/",
            holidayDescription: "Enjoy delicious meatballs"
        ),
        Holiday(
            name: "National Pack Your Lunch Day",
            month: 3,
            day: 10,
            url: "https://nationaltoday.com/national-pack-your-lunch-day/",
            holidayDescription: "Bring lunch from home"
        ),
        Holiday(
            name: "National Worship of Tools Day",
            month: 3,
            day: 11,
            url: "https://nationaltoday.com/national-worship-of-tools-day/",
            holidayDescription: "Appreciate your tools"
        ),
        Holiday(
            name: "National Plant a Flower Day",
            month: 3,
            day: 12,
            url: "https://nationaltoday.com/national-plant-a-flower-day/",
            holidayDescription: "Add beauty to your garden"
        ),
        Holiday(
            name: "National Good Samaritan Day",
            month: 3,
            day: 13,
            url: "https://nationaltoday.com/national-good-samaritan-day/",
            holidayDescription: "Help others in need"
        ),
        Holiday(
            name: "National Pi Day",
            month: 3,
            day: 14,
            url: "https://nationaltoday.com/pi-day/",
            holidayDescription: "Celebrate mathematics and pie"
        ),
        Holiday(
            name: "National Shoe the World Day",
            month: 3,
            day: 15,
            url: "https://nationaltoday.com/national-shoe-the-world-day/",
            holidayDescription: "Help provide shoes to those in need"
        ),
        Holiday(
            name: "National Artichoke Hearts Day",
            month: 3,
            day: 16,
            url: "https://nationaltoday.com/national-artichoke-hearts-day/",
            holidayDescription: "Enjoy this tasty vegetable"
        ),
        Holiday(
            name: "St. Patrick's Day",
            month: 3,
            day: 17,
            url: "https://nationaltoday.com/st-patricks-day/",
            holidayDescription: "Celebrate Irish culture"
        ),
        Holiday(
            name: "National Awkward Moments Day",
            month: 3,
            day: 18,
            url: "https://nationaltoday.com/national-awkward-moments-day/",
            holidayDescription: "Embrace life's awkward moments"
        ),
        Holiday(
            name: "National Let's Laugh Day",
            month: 3,
            day: 19,
            url: "https://nationaltoday.com/national-lets-laugh-day/",
            holidayDescription: "Share laughter and joy"
        ),
        Holiday(
            name: "International Day of Happiness",
            month: 3,
            day: 20,
            url: "https://nationaltoday.com/international-day-of-happiness/",
            holidayDescription: "Spread happiness worldwide"
        ),
        
        // April
        Holiday(
            name: "April Fools' Day",
            month: 4,
            day: 1,
            url: "https://nationaltoday.com/april-fools-day/",
            holidayDescription: "A day for pranks and jokes"
        ),
        Holiday(
            name: "National Peanut Butter and Jelly Day",
            month: 4,
            day: 2,
            url: "https://nationaltoday.com/national-peanut-butter-and-jelly-day/",
            holidayDescription: "Classic sandwich combo"
        ),
        Holiday(
            name: "National Find a Rainbow Day",
            month: 4,
            day: 3,
            url: "https://nationaltoday.com/national-find-a-rainbow-day/",
            holidayDescription: "Look for rainbows"
        ),
        Holiday(
            name: "National Walk Around Things Day",
            month: 4,
            day: 4,
            url: "https://nationaltoday.com/national-walk-around-things-day/",
            holidayDescription: "Take the scenic route"
        ),
        Holiday(
            name: "National Deep Dish Pizza Day",
            month: 4,
            day: 5,
            url: "https://nationaltoday.com/national-deep-dish-pizza-day/",
            holidayDescription: "Chicago-style pizza"
        ),
        Holiday(
            name: "National Caramel Popcorn Day",
            month: 4,
            day: 6,
            url: "https://nationaltoday.com/national-caramel-popcorn-day/",
            holidayDescription: "Sweet and crunchy snack"
        ),
        Holiday(
            name: "National Beer Day",
            month: 4,
            day: 7,
            url: "https://nationaltoday.com/national-beer-day/",
            holidayDescription: "Celebrate craft and commercial brews"
        ),
        Holiday(
            name: "National Empanada Day",
            month: 4,
            day: 8,
            url: "https://nationaltoday.com/national-empanada-day/",
            holidayDescription: "Enjoy these filled pastries"
        ),
        Holiday(
            name: "National Unicorn Day",
            month: 4,
            day: 9,
            url: "https://nationaltoday.com/national-unicorn-day/",
            holidayDescription: "Celebrate mythical creatures"
        ),
        Holiday(
            name: "National Siblings Day",
            month: 4,
            day: 10,
            url: "https://nationaltoday.com/national-siblings-day/",
            holidayDescription: "Appreciate your siblings"
        ),
        Holiday(
            name: "Earth Day",
            month: 4,
            day: 22,
            url: "https://nationaltoday.com/earth-day/",
            holidayDescription: "Protect our planet"
        ),
        Holiday(
            name: "National Superhero Day",
            month: 4,
            day: 28,
            url: "https://nationaltoday.com/national-superhero-day/",
            holidayDescription: "Honor heroes real and fictional"
        ),
        
        // May
        Holiday(
            name: "May Day",
            month: 5,
            day: 1,
            url: "https://nationaltoday.com/may-day/",
            holidayDescription: "Celebrate spring and workers"
        ),
        Holiday(
            name: "National Truffle Day",
            month: 5,
            day: 2,
            url: "https://nationaltoday.com/national-truffle-day/",
            holidayDescription: "Indulge in chocolate truffles"
        ),
        Holiday(
            name: "National Textiles Day",
            month: 5,
            day: 3,
            url: "https://nationaltoday.com/national-textiles-day/",
            holidayDescription: "Appreciate fabric and textiles"
        ),
        Holiday(
            name: "Star Wars Day",
            month: 5,
            day: 4,
            url: "https://nationaltoday.com/star-wars-day/",
            holidayDescription: "May the Fourth be with you!"
        ),
        Holiday(
            name: "National Astronaut Day",
            month: 5,
            day: 5,
            url: "https://nationaltoday.com/national-astronaut-day/",
            holidayDescription: "Honor space explorers"
        ),
        Holiday(
            name: "National Nurses Day",
            month: 5,
            day: 6,
            url: "https://nationaltoday.com/national-nurses-day/",
            holidayDescription: "Appreciate nurses' dedication"
        ),
        Holiday(
            name: "National Tourism Day",
            month: 5,
            day: 7,
            url: "https://nationaltoday.com/national-tourism-day/",
            holidayDescription: "Explore new places"
        ),
        Holiday(
            name: "National Have a Coke Day",
            month: 5,
            day: 8,
            url: "https://nationaltoday.com/national-have-a-coke-day/",
            holidayDescription: "Enjoy a refreshing Coca-Cola"
        ),
        Holiday(
            name: "National Lost Sock Memorial Day",
            month: 5,
            day: 9,
            url: "https://nationaltoday.com/national-lost-sock-memorial-day/",
            holidayDescription: "Remember all the lost socks"
        ),
        Holiday(
            name: "Mother's Day",
            month: 5,
            day: 10,
            url: "https://nationaltoday.com/mothers-day/",
            holidayDescription: "Honor mothers everywhere"
        ),
        
        // June
        Holiday(
            name: "National Doughnut Day",
            month: 6,
            day: 6,
            url: "https://nationaltoday.com/national-doughnut-day/",
            holidayDescription: "Enjoy free doughnuts"
        ),
        Holiday(
            name: "National Best Friends Day",
            month: 6,
            day: 8,
            url: "https://nationaltoday.com/national-best-friends-day/",
            holidayDescription: "Celebrate your best friend"
        ),
        Holiday(
            name: "Father's Day",
            month: 6,
            day: 21,
            url: "https://nationaltoday.com/fathers-day/",
            holidayDescription: "Honor fathers everywhere"
        ),
        
        // July
        Holiday(
            name: "Independence Day",
            month: 7,
            day: 4,
            url: "https://nationaltoday.com/independence-day/",
            holidayDescription: "American independence celebration"
        ),
        Holiday(
            name: "World Emoji Day",
            month: 7,
            day: 17,
            url: "https://nationaltoday.com/world-emoji-day/",
            holidayDescription: "Celebrate digital expression 😊"
        ),
        Holiday(
            name: "National Ice Cream Day",
            month: 7,
            day: 20,
            url: "https://nationaltoday.com/national-ice-cream-day/",
            holidayDescription: "Cool down with ice cream"
        ),
        
        // August
        Holiday(
            name: "National Friendship Day",
            month: 8,
            day: 1,
            url: "https://nationaltoday.com/national-friendship-day/",
            holidayDescription: "Celebrate your friends"
        ),
        Holiday(
            name: "International Cat Day",
            month: 8,
            day: 8,
            url: "https://nationaltoday.com/international-cat-day/",
            holidayDescription: "Celebrate feline friends"
        ),
        Holiday(
            name: "National Tell a Joke Day",
            month: 8,
            day: 16,
            url: "https://nationaltoday.com/national-tell-a-joke-day/",
            holidayDescription: "Share laughter"
        ),
        Holiday(
            name: "National Dog Day",
            month: 8,
            day: 26,
            url: "https://nationaltoday.com/national-dog-day/",
            holidayDescription: "Celebrate man's best friend"
        ),
        
        // September
        Holiday(
            name: "Labor Day",
            month: 9,
            day: 1,
            url: "https://nationaltoday.com/labor-day/",
            holidayDescription: "Honor American workers"
        ),
        Holiday(
            name: "International Day of Peace",
            month: 9,
            day: 21,
            url: "https://nationaltoday.com/international-day-of-peace/",
            holidayDescription: "Promote world peace"
        ),
        Holiday(
            name: "National Coffee Day",
            month: 9,
            day: 29,
            url: "https://nationaltoday.com/national-coffee-day/",
            holidayDescription: "Enjoy your favorite brew"
        ),
        
        // October
        Holiday(
            name: "World Smile Day",
            month: 10,
            day: 3,
            url: "https://nationaltoday.com/world-smile-day/",
            holidayDescription: "Spread smiles and kindness"
        ),
        Holiday(
            name: "National Taco Day",
            month: 10,
            day: 4,
            url: "https://nationaltoday.com/national-taco-day/",
            holidayDescription: "Enjoy delicious tacos"
        ),
        Holiday(
            name: "National Dessert Day",
            month: 10,
            day: 14,
            url: "https://nationaltoday.com/national-dessert-day/",
            holidayDescription: "Indulge your sweet tooth"
        ),
        Holiday(
            name: "Halloween",
            month: 10,
            day: 31,
            url: "https://nationaltoday.com/halloween/",
            holidayDescription: "Costumes, candy, and spooks"
        ),
        
        // November
        Holiday(
            name: "National Sandwich Day",
            month: 11,
            day: 3,
            url: "https://nationaltoday.com/national-sandwich-day/",
            holidayDescription: "Enjoy your favorite sandwich"
        ),
        Holiday(
            name: "World Kindness Day",
            month: 11,
            day: 13,
            url: "https://nationaltoday.com/world-kindness-day/",
            holidayDescription: "Promote kindness globally"
        ),
        Holiday(
            name: "Thanksgiving",
            month: 11,
            day: 27,
            url: "https://nationaltoday.com/thanksgiving/",
            holidayDescription: "Give thanks with family"
        ),
        Holiday(
            name: "Black Friday",
            month: 11,
            day: 28,
            url: "https://nationaltoday.com/black-friday/",
            holidayDescription: "Shopping deals galore"
        ),
        
        // December
        Holiday(
            name: "World AIDS Day",
            month: 12,
            day: 1,
            url: "https://nationaltoday.com/world-aids-day/",
            holidayDescription: "Raise AIDS awareness"
        ),
        Holiday(
            name: "National Cookie Day",
            month: 12,
            day: 4,
            url: "https://nationaltoday.com/national-cookie-day/",
            holidayDescription: "Bake and enjoy cookies"
        ),
        Holiday(
            name: "Christmas Eve",
            month: 12,
            day: 24,
            url: "https://nationaltoday.com/christmas-eve/",
            holidayDescription: "The night before Christmas"
        ),
        Holiday(
            name: "Christmas Day",
            month: 12,
            day: 25,
            url: "https://nationaltoday.com/christmas-day/",
            holidayDescription: "Celebrate with loved ones"
        ),
        Holiday(
            name: "New Year's Eve",
            month: 12,
            day: 31,
            url: "https://nationaltoday.com/new-years-eve/",
            holidayDescription: "Ring in the new year"
        ),
    ]
}

// MARK: - Sample Holiday Data

private func generateSampleHolidays() -> [Holiday] {
    [
        // January
        Holiday(name: "New Year's Day", month: 1, day: 1, url: "https://nationaltoday.com/new-years-day/", holidayDescription: "A day to celebrate the beginning of a new year"),
        Holiday(name: "National Thank God It's Monday Day", month: 1, day: 6, url: "https://nationaltoday.com/national-thank-god-its-monday-day/", holidayDescription: "A day to embrace Mondays with positivity"),
        Holiday(name: "National Popcorn Day", month: 1, day: 19, url: "https://nationaltoday.com/national-popcorn-day/", holidayDescription: "Celebrate one of America's favorite snacks"),
        
        // February
        Holiday(name: "Groundhog Day", month: 2, day: 2, url: "https://nationaltoday.com/groundhog-day/", holidayDescription: "Will the groundhog see his shadow?"),
        Holiday(name: "Valentine's Day", month: 2, day: 14, url: "https://nationaltoday.com/valentines-day/", holidayDescription: "A day to celebrate love and affection"),
        Holiday(name: "Random Acts of Kindness Day", month: 2, day: 17, url: "https://nationaltoday.com/random-acts-of-kindness-day/", holidayDescription: "Spread kindness and make someone's day"),
        
        // March
        Holiday(name: "National Employee Appreciation Day", month: 3, day: 7, url: "https://nationaltoday.com/national-employee-appreciation-day/", holidayDescription: "Recognize the hard work of employees"),
        Holiday(name: "St. Patrick's Day", month: 3, day: 17, url: "https://nationaltoday.com/st-patricks-day/", holidayDescription: "Celebrate Irish culture and heritage"),
        Holiday(name: "International Day of Happiness", month: 3, day: 20, url: "https://nationaltoday.com/international-day-of-happiness/", holidayDescription: "Spread joy and happiness worldwide"),
        
        // April
        Holiday(name: "April Fools' Day", month: 4, day: 1, url: "https://nationaltoday.com/april-fools-day/", holidayDescription: "A day for pranks and jokes"),
        Holiday(name: "Earth Day", month: 4, day: 22, url: "https://nationaltoday.com/earth-day/", holidayDescription: "Celebrate and protect our planet"),
        Holiday(name: "National Superhero Day", month: 4, day: 28, url: "https://nationaltoday.com/national-superhero-day/", holidayDescription: "Honor superheroes, real and fictional"),
        
        // May
        Holiday(name: "May Day", month: 5, day: 1, url: "https://nationaltoday.com/may-day/", holidayDescription: "Celebrate spring and workers' rights"),
        Holiday(name: "Star Wars Day", month: 5, day: 4, url: "https://nationaltoday.com/star-wars-day/", holidayDescription: "May the Fourth be with you!"),
        Holiday(name: "Mother's Day", month: 5, day: 10, url: "https://nationaltoday.com/mothers-day/", holidayDescription: "Honor and celebrate mothers"),
        
        // June
        Holiday(name: "National Donut Day", month: 6, day: 6, url: "https://nationaltoday.com/national-donut-day/", holidayDescription: "Celebrate the delicious donut"),
        Holiday(name: "Father's Day", month: 6, day: 21, url: "https://nationaltoday.com/fathers-day/", holidayDescription: "Honor and celebrate fathers"),
        Holiday(name: "International Day of Yoga", month: 6, day: 21, url: "https://nationaltoday.com/international-yoga-day/", holidayDescription: "Practice yoga and mindfulness"),
        
        // July
        Holiday(name: "Independence Day", month: 7, day: 4, url: "https://nationaltoday.com/independence-day/", holidayDescription: "Celebrate American independence"),
        Holiday(name: "World Emoji Day", month: 7, day: 17, url: "https://nationaltoday.com/world-emoji-day/", holidayDescription: "Celebrate digital expression 😊"),
        Holiday(name: "National Ice Cream Day", month: 7, day: 20, url: "https://nationaltoday.com/national-ice-cream-day/", holidayDescription: "Enjoy your favorite frozen treat"),
        
        // August
        Holiday(name: "International Cat Day", month: 8, day: 8, url: "https://nationaltoday.com/international-cat-day/", holidayDescription: "Celebrate our feline friends"),
        Holiday(name: "National Tell a Joke Day", month: 8, day: 16, url: "https://nationaltoday.com/national-tell-a-joke-day/", holidayDescription: "Share laughter and humor"),
        Holiday(name: "National Dog Day", month: 8, day: 26, url: "https://nationaltoday.com/national-dog-day/", holidayDescription: "Celebrate man's best friend"),
        
        // September
        Holiday(name: "Labor Day", month: 9, day: 1, url: "https://nationaltoday.com/labor-day/", holidayDescription: "Honor American workers"),
        Holiday(name: "International Day of Peace", month: 9, day: 21, url: "https://nationaltoday.com/international-day-of-peace/", holidayDescription: "Promote peace worldwide"),
        Holiday(name: "National Coffee Day", month: 9, day: 29, url: "https://nationaltoday.com/national-coffee-day/", holidayDescription: "Celebrate the beloved coffee"),
        
        // October
        Holiday(name: "World Smile Day", month: 10, day: 3, url: "https://nationaltoday.com/world-smile-day/", holidayDescription: "Spread smiles and kindness"),
        Holiday(name: "National Taco Day", month: 10, day: 4, url: "https://nationaltoday.com/national-taco-day/", holidayDescription: "Celebrate the delicious taco"),
        Holiday(name: "Halloween", month: 10, day: 31, url: "https://nationaltoday.com/halloween/", holidayDescription: "Spooky costumes and candy"),
        
        // November
        Holiday(name: "World Kindness Day", month: 11, day: 13, url: "https://nationaltoday.com/world-kindness-day/", holidayDescription: "Promote kindness worldwide"),
        Holiday(name: "Thanksgiving", month: 11, day: 27, url: "https://nationaltoday.com/thanksgiving/", holidayDescription: "Give thanks and celebrate with family"),
        Holiday(name: "Black Friday", month: 11, day: 28, url: "https://nationaltoday.com/black-friday/", holidayDescription: "Shopping deals and sales"),
        
        // December
        Holiday(name: "World AIDS Day", month: 12, day: 1, url: "https://nationaltoday.com/world-aids-day/", holidayDescription: "Raise awareness about AIDS"),
        Holiday(name: "Christmas Eve", month: 12, day: 24, url: "https://nationaltoday.com/christmas-eve/", holidayDescription: "The night before Christmas"),
        Holiday(name: "Christmas Day", month: 12, day: 25, url: "https://nationaltoday.com/christmas-day/", holidayDescription: "Celebrate the birth of Jesus Christ"),
        Holiday(name: "New Year's Eve", month: 12, day: 31, url: "https://nationaltoday.com/new-years-eve/", holidayDescription: "Celebrate the end of the year"),
    ]
}
