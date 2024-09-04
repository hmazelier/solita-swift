import Foundation

func mapLatestIdl(data: Data, decoder: JSONDecoder?) throws -> Idl {
    let decoder = decoder ?? .init()
    return try decoder.decode(IdlV2.self, from: data)
        .toIdlV1()
}
