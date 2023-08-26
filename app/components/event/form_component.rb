# frozen_string_literal: true

class Event
  class FormComponent < ApplicationComponent
    # @param event [Event]
    def initialize(event:)
      @event = event
    end

    # @return [Array<Discord::Guild>]
    def guilds
      @guilds ||= Discord::Guild.all.to_a
    end
  end
end
