import Foundation

public typealias IdlMappingBlock = (Data, JSONDecoder?) throws -> Idl

public enum IdlMapper {
    case latest
    
    public var mapper: IdlMappingBlock {
        switch self {
        case .latest:
            mapLatestIdl(data:decoder:)
        }
    }
}
