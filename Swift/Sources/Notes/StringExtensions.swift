extension String {
    func preview(maxLength: Int) -> String {
        let limit = max(0, maxLength)
        guard limit > 0 else { return "" }
        guard unicodeScalars.count > limit else { return self }

        let suffix = String("...".prefix(limit))
        let contentLength = limit - suffix.count
        return String(String.UnicodeScalarView(unicodeScalars.prefix(contentLength))) + suffix
    }
}
