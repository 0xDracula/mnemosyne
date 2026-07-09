module Moderation
  class MemberProfile < ApplicationRecord
    self.table_name = "moderation.member_profile"
    self.primary_key = "user_id"

    def readonly?
      true
    end
  end
end
