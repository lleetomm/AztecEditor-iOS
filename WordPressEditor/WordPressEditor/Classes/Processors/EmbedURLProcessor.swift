import Foundation

public struct EmbedURLProcessor{

    let url: URL

    init(url: URL){
        self.url = url
    }

    public var isValidEmbed: Bool{

        return [
            isYouTubeEmbed,
            isVimeoEmbed,
            isTwitterEmbed,
            isFlickrEmbed,
            isIssuuEmbed,
            isInstagramEmbed,
        ].first != nil
    }

    /// Tests the url to see if it's a valid YouTube URL.
    ///
    /// Supports these formats:
    ///  - Watch URL
    ///  - Embed URL
    ///  - Short URL
    ///
    public var isYouTubeEmbed: Bool {

        return matchesAnyOf([
            pattern("^https?://(www.|m.)?youtube.com/(watch\\?v=|embed/)[0-9|a-z|A-Z|_|-]+$"),  // Full URL
            pattern("^https?://youtu.be/[0-9|a-z|A-Z|_|-]+$"),                                  // Short URL
            pattern("^https?://((m|www)\\.)?youtube\\.com/playlist[\\S]+$"),                    // Playlist URL
        ])
    }

    /// Tests the url to see if it's a valid Vimeo URL.
    ///
    /// Supports these formats:
    ///  - Watch URL
    ///  - Channel URL
    ///  - Embedded Player URL
    ///
    public var isVimeoEmbed: Bool {
        let pattern = "^https?://vimeo.com/[0-9]+$"
        let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])

        let channelPattern = "^https?://vimeo.com/channels/[0-9|a-z|A-Z]+/[0-9]+$"
        let channel = try! NSRegularExpression(pattern: channelPattern, options: [.caseInsensitive])

        let playerPattern = "^https://player.vimeo.com/video/[0-9]+$"
        let player = try! NSRegularExpression(pattern: playerPattern, options: [.caseInsensitive])

        return matches(regex) || matches(channel) || matches(player)
    }

    /// Tests the url to see if it's a valid Twitter URL.
    ///
    /// Supports these formats:
    ///  - Tweet
    ///  - Profile
    ///  - Likes
    ///  - List
    ///  - Moment

    public var isTwitterEmbed: Bool {

        return matchesAnyOf([
            pattern("https?://(www\\.)?twitter\\.com/\\w{1,15}/status(es)?/[\\S]+$"),   // Status
            pattern("https?://(www\\.)?twitter\\.com/\\w{1,15}$"),                      // Profile
            pattern("https?://(www\\.)?twitter\\.com/\\w{1,15}/likes$"),                // Likes
            pattern("https?://(www\\.)?twitter\\.com/\\w{1,15}/lists/[\\S]+$"),         // List
            pattern("https?://(www\\.)?twitter\\.com/i/moments/[\\S]+$"),               // Moments
        ])
    }

    /// Tests the url to see if it's a valid Flickr URL.
    ///
    /// Supports these formats:
    ///  - Photo URL
    ///  - Gallery URL
    ///  - Flic.kr short URLs (photos and galleries)
    ///
    public var isFlickrEmbed: Bool {
        let regex = pattern("^https?://(www.)?(flickr.com|flic\\.kr)/(photos|p|s)/[\\S]+$")
        return matches(regex)
    }

    /// Tests the url to see if it's a valid Issuu URL.
    public var isIssuuEmbed: Bool {
        return matches(pattern("^https?://(www\\.)?issuu\\.com/.+/docs/[\\S]+$"))
    }

    /// Tests the url to see if it's a valid Instagram URL.
    public var isInstagramEmbed: Bool {
        return matches(pattern("^https?://(www\\.)?instagr(\\.am|am\\.com)/p/[\\S]+$"))
    }

    private func pattern(_ pattern: String) -> NSRegularExpression {
        return try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
    }

    private func matchesAnyOf(_ regexes: [NSRegularExpression]) -> Bool{
        return regexes.first{ matches($0) } != nil
    }

    private func matches(_ regex: NSRegularExpression) -> Bool {
        let urlRange = NSMakeRange(0, url.absoluteString.lengthOfBytes(using: .utf8))
        let urlString = url.absoluteString

        return !regex.matches(in: urlString, options: [], range: urlRange).isEmpty
    }
}
