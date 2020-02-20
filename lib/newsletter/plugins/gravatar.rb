require 'digest/md5'

module Newsletter
  class Gravatar
    class << self
      def get_image_url(email, size = 80)
        hash = Digest::MD5.hexdigest(email.strip.downcase)
        return "https://s.gravatar.com/avatar/#{hash}?s=#{size}"
      end
    end

    private_class_method :new
  end
end
