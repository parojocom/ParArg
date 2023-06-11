public struct ParArg {
    
    public let name: String
    public let value: String?
    
    public static func parse(inputs: [String], paramPrefixes: [String] = ["--", "-"]) -> [ParArg] {
        let rawParams = Parser.parse(inputs: inputs, prefixes: paramPrefixes)
        
        return rawParams.compactMap {
            guard let param = $0.param else {
                return nil
            }
            return ParArg(name: param, value: $0.arg)
        }
    }
}

extension ParArg: Equatable {
    
}

public extension Array where Element == ParArg {
    subscript(name: String) -> ParArg? {
        return self.first { $0.name == name }
    }
    
    func value(for paramName: String) -> String? {
        return self[paramName]?.value
    }
}
