//
//  File.swift
//  
//
//  Created by 2fletch on 2020-12-06.
//

import Foundation

struct Parser {
    typealias RawPararg = (param: String?, arg: String?)
    
    public static func parse(inputs: [String], prefixes: [String]) -> [RawPararg] {
        var ret = [RawPararg]()
        
        var prevPararg: RawPararg?
        
        for input in inputs {
            let currPararg = parse(input: input, prefixes: prefixes)
            
            if prevPararg == nil && currPararg.param != nil && currPararg.arg == nil {
                prevPararg = currPararg
            } else if currPararg.arg != nil && currPararg.param != nil {
                if prevPararg != nil {
                    ret.append(prevPararg!)
                }
                ret.append(currPararg)
                prevPararg = nil
            } else if currPararg.arg != nil && currPararg.param == nil &&
                prevPararg?.param != nil && prevPararg?.arg == nil {
                // join them
                ret.append((prevPararg!.param!, currPararg.arg!))
                prevPararg = nil
            }
        }
        
        if prevPararg != nil {
            ret.append(prevPararg!)
        }
        
        return ret
    }
    
    private static func parse(input: String, prefixes: [String]) -> RawPararg {
        let param = parseParam(input, prefixes: prefixes)
        guard param.param != nil else {
            return (nil, input)
        }
        return param
    }
    
    private static func parseParam(_ input: String, prefixes: [String]) -> RawPararg {
        var input = input
        var paramPrefixTmp: String?
        
        for prefix in prefixes {
            if input.starts(with: prefix) {
                paramPrefixTmp = prefix
                break
            }
        }
        
        guard let paramPrefix = paramPrefixTmp else {
            return (nil, nil)
        }
        
        input = String(input.dropFirst(paramPrefix.count))

        if !input.containsNonAlnum {
            return (paramPrefix + input, nil)
        }
        
        guard var nonAlnumIdx = input.firstNonAlnum else {
            return (paramPrefix + input, nil)
        }
        
        guard input[nonAlnumIdx] == "=" else {
            return (nil, nil)
        }
        let par = String(input[input.startIndex ..< nonAlnumIdx])
        
        nonAlnumIdx = input.index(after: nonAlnumIdx)
        
        if nonAlnumIdx == input.endIndex {
            return (nil, nil)
        }
        
        let arg = String(input[nonAlnumIdx ..< input.endIndex])
        return (paramPrefix + par, arg)
    }
}

extension Character {
    var isAlnum: Bool {
        return self.isASCII && (self.isLetter || self.isNumber)
    }
}

extension String {
    var firstNonAlnum: Index? {
        return self.firstIndex { !$0.isAlnum }
    }
    
    var containsNonAlnum: Bool {
        return firstNonAlnum != nil
    }
}
