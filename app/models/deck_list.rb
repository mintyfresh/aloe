# frozen_string_literal: true

# == Schema Information
#
# Table name: deck_lists
#
#  id              :bigint           not null, primary key
#  registration_id :bigint           not null
#  deck_name       :string           not null
#  pony_head_url   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_deck_lists_on_registration_id  (registration_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (registration_id => registrations.id)
#
class DeckList < ApplicationRecord
  belongs_to :registration, inverse_of: :deck_list

  validates :deck_name, presence: true
  validates :pony_head_url, presence: true, uri: { scheme: %w[http https], host: 'ponyhead.com', path: '/deckbuilder' }

  validate if: -> { pony_head_url_changed? && errors.none? } do
    cards.present? or errors.add(:pony_head_url, :invalid)
  end

  # Returns a hash of card codes and counts from the Pony Head URL-encoded decklist.
  #
  # @return [Hash{String => Integer}]
  def cards
    query = Rack::Utils.parse_query(URI.parse(pony_head_url).query)
    return if query['v1code'].blank?

    query['v1code'].split('-').to_h do |card_with_count|
      card, count = card_with_count.split(/x(\d)\z/)

      [card, count.to_i]
    end
  end
end
