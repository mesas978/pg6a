import Fluent

struct CreateTodo: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("todo")
            .id()
            .field("title", .string)
            .create()
    }


    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("todo").delete()
    }
}
