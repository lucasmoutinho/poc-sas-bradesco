class Procedure < ApplicationRecord
    def rails_admin_title
        "#{code}: #{description}"
    end
end
