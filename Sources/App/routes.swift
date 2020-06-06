import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get("complaint") { req in
        Complaint.query(on: req.db).all()
    }

    app.post("complaint") { req -> EventLoopFuture<Complaint> in
        let complaint = try req.content.decode(Complaint.self)
        if let id = complaint.id {
            print("60p \(id)") // Optional(6005)
        }
        return complaint.save(on: req.db)
            .map { complaint }
    }

    try app.register(collection: TodoController())
}
