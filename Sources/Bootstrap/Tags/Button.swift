import Leaf
import Sugar
import TemplateKit

public final class ButtonTag: TagRenderer {
    /// A button style can be any of `ColorKeys` or "link".
    public enum Keys: String {
        case link
    }

    public func render(tag: TagContext) throws -> Future<TemplateData> {
        let body = try tag.requireBody()

        var style = ColorKeys.primary.rawValue
        var classes = ""
        var attributes = ""

        for index in 0...2 {
            if
                let param = tag.parameters[safe: index]?.string,
                !param.isEmpty
            {
                switch index {
                case 0: style = param
                case 1: classes = param
                case 2: attributes = param
                default: break
                }
            }
        }

        guard ColorKeys(rawValue: style) != nil || Keys(rawValue: style) != nil else {
            throw tag.error(reason: "Wrong argument given: \(style)")
        }

        return tag.serializer.serialize(ast: body).map(to: TemplateData.self) { body in
            let c = "btn btn-\(style) \(classes)"
            let b = String(data: body.data, encoding: .utf8) ?? ""

            let button = "<button class='\(c)' \(attributes)>\(b)</button>"
            return .string(button)
        }
    }
}
