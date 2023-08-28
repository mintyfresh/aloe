# frozen_string_literal: true

module Discord
  module Templates
    class Base
      # @return [Hash]
      def self.render(...)
        new(...).render
      end

      # @abstract
      # @return [Hash]
      def render
        raise NotImplementedError, "#{self.class.name}#render is not implemented"
      end
    end
  end
end
