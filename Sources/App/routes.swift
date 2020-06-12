import Fluent
import Vapor
import Leaf

// https://theswiftdev.com/custom-leaf-tags-in-vapor-4/
struct PathTag: LeafTag {
    static let name = "name"
    func render(_ ctx: LeafContext) throws -> LeafData {
        print("31c")
        let value = ctx.request?.url.path ?? ""
        return .string(value)
    }
}

struct CountTag: LeafTag {
    static let name = "count"
    func render(_ ctx: LeafContext) throws -> LeafData {
        print("11m")
        guard let items = ctx.parameters.first?.array else {
            throw "unable to get parameter key"
        }
        return .int(items.count)
    }
}


struct IsEmptyTag: LeafTag {
    static let name = "isEmpty"
    func render(_ ctx: LeafContext) throws -> LeafData {
        print("01d")
        guard let items = ctx.parameters.first?.array else {
            throw "unable to get parameter key"
        }
        return .bool(items.isEmpty)
    }
}


func routes(_ app: Application) throws {
    let todoController = TodoController()
    app.post("todo", use: todoController.create)
    app.get("todo", use: todoController.readAll)
    app.get("todo", ":id", use: todoController.read)
    app.post("todo", ":id", use: todoController.update)
    app.delete("todo", ":id", use: todoController.delete)
    /*
    app.get { req in
        return "It works!"
    }
    
    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    */
    // https://theswiftdev.com/custom-leaf-tags-in-vapor-4/
    
    app.leaf.tags[PathTag.name] = PathTag()
    app.leaf.tags[CountTag.name] = CountTag()
    app.leaf.tags[IsEmptyTag.name] = IsEmptyTag()
     
    
    app.get { req in
        req.view.render("index", [
            "title": "Hi",
            "body": "bonjour le monde"
            
        ])
    }
    
    app.get("complaint") { req in
        
        Complaint.query(on: req.db).all()
    }
    
    app.post("complaint") { req -> EventLoopFuture<Complaint> in
        let complaint = try req.content.decode(Complaint.self)
        complaint.updated = Date()
        if let id = complaint.id {
            print("60p \(id)") // Optional(6005)
        }
        return complaint.save(on: req.db)
            .map { complaint }
    }
    
    // https://github.com/vapor/leaf/releases
    app.get("test-file") { req in
        req.view.render(#file, ["foo": "bars"])
    }
    
    
}
