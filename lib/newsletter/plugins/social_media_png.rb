module Newsletter
  class SocialMediaPNG < SocialMedia
    @@dir = 'assets/images/social_media/'

    class << self
      def create_twitter_link(username)
        url = super
        img = 'Twitter.png'
        return create_icon_link(url, img)
      end

      def create_facebook_link(username)
        url = super
        img = 'Facebook.png'
        return create_icon_link(url, img)
      end

      def create_instagram_link(username)
        url = super
        img = 'Instagram.png'
        return create_icon_link(url, img)
      end

      def create_github_link(username)
        url = super
        img = 'GitHub.png'
        return create_icon_link(url, img)
      end

      def create_medium_link(username)
        url = super
        img = 'Medium.png'
        return create_icon_link(url, img)
      end

      def create_linkedin_link(username)
        url = super
        img = 'LinkedIn.png'
        return create_icon_link(url, img)
      end

      def create_link_link(url)
        url = super
        img = 'Link.png'
        return create_icon_link(url, img)
      end

      def create_icon_link(url, img)
        return %Q(<a href="#{url}"><img width="24px" height="auto" src="#{@@dir + img}" /></a>)
      end
    end

    private_class_method :new, :create_icon_link
  end
end
