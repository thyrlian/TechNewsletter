module Newsletter
  class SocialMediaPNG
    @@dir = 'assets/images/social_media/'

    class << self
      def create_twitter_link(username)
        url = "https://twitter.com/#{username}"
        img = @@dir + 'Twitter.png'
        return create_icon_link(url, img)
      end

      def create_facebook_link(username)
        url = "https://www.facebook.com/#{username}"
        img = @@dir + 'Facebook.png'
        return create_icon_link(url, img)
      end

      def create_instagram_link(username)
        url = "https://www.instagram.com/#{username}"
        img = @@dir + 'Instagram.png'
        return create_icon_link(url, img)
      end

      def create_github_link(username)
        url = "https://github.com/#{username}"
        img = @@dir + 'GitHub.png'
        return create_icon_link(url, img)
      end

      def create_medium_link(username)
        url = "https://medium.com/@#{username}"
        img = @@dir + 'Medium.png'
        return create_icon_link(url, img)
      end

      def create_linkedin_link(username)
        url = "https://www.linkedin.com/in/#{username}"
        img = @@dir + 'LinkedIn.png'
        return create_icon_link(url, img)
      end

      def create_link_link(url)
        img = @@dir + 'Link.png'
        return create_icon_link(url, img)
      end

      def create_icon_link(url, img)
        return %Q(<a href="#{url}"><img width="24px" height="auto" src="#{img}" /></a>)
      end
    end

    private_class_method :new, :create_icon_link
  end
end
