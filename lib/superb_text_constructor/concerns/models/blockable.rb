module SuperbTextConstructor
  module Concerns
    module Models
      module Blockable
        extend ActiveSupport::Concern

        included do
          has_many :blocks, class_name: 'SuperbTextConstructor::Block', as: :blockable, dependent: :destroy, inverse_of: :blockable
        end

      end
    end
  end
end