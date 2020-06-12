import Fluent

struct CreateComplaint: Migration {
    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("cw_complaint5_temp")
            .id()
            .field("issue_description", .string)
            .field("county_id", .int)
            .field("city_id", .int)
            .field("section", .int)
            .field("api_county_code", .int)
            .field("api_state_code", .int)
            .field("api_sequence_number", .int)
            .field("document_number", .int)
            .field("updated", .date)
            .create()
    }
/*

     @ID(custom: "id", generatedBy: .database) var id: Int?
     //@ID(key: "id") var id: Int?
     
      //var id: Int? worked in Vapor 3
     
     @Field(key: "issue_description")
     var issue_description: String
     
     @Field(key: "document_number")
     var document_number: Int
     
     @Field(key: "api_state_code")
     var api_state_code: Int
     
     @Field(key: "api_county_code")
     var api_county_code: Int
     
     @Field(key: "api_sequence_number")
     var api_sequence_number: Int

     @Field(key: "section")
     var section: Int
     
     @Field(key: "city_id")
     var city_id: Int
     
     @Field(key: "county_id")
     var county_id: Int
     
     @Field(key: "operator_id")
     var operator_id: Int
     
     @Field(key: "updated")
     var updated: Date

     */
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("galaxies").delete()
    }
}
