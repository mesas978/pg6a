import Fluent
import Vapor

struct TodoController {
    func create(req: Request) throws -> EventLoopFuture<Todo.Output> {
        let input = try req.content.decode(Todo.Input.self)
        let todo = Todo(title: input.title)
        return todo.save(on: req.db)
            .map { Todo.Output(id: todo.id!.uuidString, title: todo.title) }
    }
    
    func readAll(req: Request) throws -> EventLoopFuture<Page<Todo.Output>> {
        return Todo.query(on: req.db).paginate(for: req).map { page in
            page.map { Todo.Output(id: $0.id!.uuidString, title: $0.title) }
        }
    }
    
    func read(req: Request) throws -> EventLoopFuture<Todo.Output> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Todo.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .map { Todo.Output(id: $0.id!.uuidString, title: $0.title) }
    }
    
    func update(req: Request) throws -> EventLoopFuture<Todo.Output> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        let input = try req.content.decode(Todo.Input.self)
        return Todo.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { todo in
                todo.title = input.title
                return todo.save(on: req.db)
                    .map { Todo.Output(id: todo.id!.uuidString, title: todo.title) }
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Todo.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .map { .ok }
    }
    // ...
}
