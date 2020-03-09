module Newsletter
  class SocialMedia
    class << self
      def create_twitter_link(username)
        url = "https://twitter.com/#{username}"
        icon_class = 'fab fa-twitter'
        return create_icon_link(url, icon_class)
      end

      def create_facebook_link(username)
        url = "https://www.facebook.com/#{username}"
        icon_class = 'fab fa-facebook'
        return create_icon_link(url, icon_class)
      end

      def create_instagram_link(username)
        url = "https://www.instagram.com/#{username}"
        icon_class = 'fab fa-instagram'
        return create_icon_link(url, icon_class)
      end

      def create_github_link(username)
        url = "https://github.com/#{username}"
        icon_class = 'fab fa-github'
        return create_icon_link(url, icon_class)
      end

      def create_medium_link(username)
        url = "https://medium.com/@#{username}"
        icon_class = 'fab fa-medium'
        return create_icon_link(url, icon_class)
      end

      def create_linkedin_link(username)
        url = "https://www.linkedin.com/in/#{username}"
        icon_class = 'fab fa-linkedin-in'
        return create_icon_link(url, icon_class)
      end

      def create_link_link(url)
        create_icon_link(url, 'fas fa-link')
      end

      def create_icon_link(url, icon_class)
        return %Q(<a href="#{url}"><i class="#{icon_class}"> </i></a>)
      end
    end

    private_class_method :new, :create_icon_link
  end
end
