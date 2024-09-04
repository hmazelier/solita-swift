import Foundation

public struct IdlV2: Decodable {
    let address: String
    let metadata: Metadata
    let instructions: [Instruction]
    let accounts: [Account]
    let errors: [ProgramError]
    let types: [IdlDefinedTypeDefinition]
    
    struct Metadata: Decodable {
        let name: String
        let version: String
        let spec: String
        let description: String
    }
    
    struct Instruction: Decodable {
        let name: String
        let discriminator: [UInt8]
        let accounts: [InstructionAccount]
        let args: [String]
        let returns: String?
        
        struct InstructionAccount: Decodable {
            let name: String
            let writable: Bool?
            let signer: Bool?
            let pda: PDA?
            let address: String?
            
            struct PDA: Decodable {
                let seeds: [Seed]
                let program: Program?
                
                struct Seed: Decodable {
                    let kind: String
                    let value: [UInt8]?
                    let path: String?
                }
                
                struct Program: Decodable {
                    let kind: String
                    let value: [UInt8]
                }
            }
        }
    }
    
    struct Account: Decodable {
        let name: String
        let discriminator: [UInt8]
    }
    
    struct ProgramError: Decodable {
        let code: Int
        let name: String
        let msg: String
    }
    
    public func toIdlV1() -> Idl {
        let idlV2 = self
        let instructions = idlV2.instructions.map { instruction in
            IdlInstruction(
                name: instruction.name,
                accounts: instruction.accounts.map { account in
                    IdlInstructionAccount(
                        name: account.name,
                        isMut: account.writable ?? false,
                        isSigner: account.signer ?? false,
                        desc: nil,
                        optional: nil
                    )
                },
                args: instruction.args.map { arg in
                    IdlField(name: arg, type: .beetTypeMapKey(.stringTypeMapKey(.string)), attrs: nil)
                },
                defaultOptionalAccounts: nil,
                docs: nil
            )
        }
        
        let accounts = idlV2.accounts.map { account in
            IdlAccount(name: account.name, type: IdlDefinedType(kind: .struct, fields: []))
        }
        
        let errors = idlV2.errors.map { error in
            IdlError(code: error.code, name: error.name, msg: error.msg)
        }
        
        return Idl(
            version: idlV2.metadata.version,
            name: idlV2.metadata.name,
            instructions: instructions,
            state: nil,
            accounts: accounts,
            types: idlV2.types,
            events: nil,
            errors: errors,
            metadata: IdlMetadata(address: idlV2.address)
        )
    }
}
