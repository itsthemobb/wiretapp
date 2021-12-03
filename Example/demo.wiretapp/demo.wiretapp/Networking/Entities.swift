struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct User: Decodable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let address: Address
    
    struct Address: Decodable {
        let street: String
        let suite: String
        let city: String
        let zipcode: String
    }
}
