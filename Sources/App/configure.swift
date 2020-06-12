import Fluent
import FluentPostgresDriver
import Vapor
import JWT




public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Configure Leaf
    app.views.use(.leaf)
    app.leaf.cache.isEnabled = app.environment.isRelease
    
    
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        username: Environment.get("DATABASE_USERNAME") ?? "postgres",
        password: Environment.get("DATABASE_PASSWORD") ?? "secret",
        database: Environment.get("DATABASE_NAME") ?? "mydb2"
    ), as: .psql)

    //p.migrations.add(CreateTodo())
    //p.migrations.add(CreateGalaxy())
    //p.migrations.add(CreateComplaint())
    

    
    // register routes
    try routes(app)
}
