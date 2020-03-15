module Newsletter
  class SocialMedia
    class << self
      def create_twitter_link(username)
        return "https://twitter.com/#{username}"
      end

      def create_facebook_link(username)
        return "https://www.facebook.com/#{username}"
      end

      def create_instagram_link(username)
        return "https://www.instagram.com/#{username}"
      end

      def create_github_link(username)
        return "https://github.com/#{username}"
      end

      def create_medium_link(username)
        return "https://medium.com/@#{username}"
      end

      def create_linkedin_link(username)
        return "https://www.linkedin.com/in/#{username}"
      end

      def create_link_link(url)
        return url
      end

      def create_icon_link(url, svg_path)
        raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
      end
    end

    private_class_method :new, :create_icon_link
  end
end
