module Analytics
  class MemberActivity < ApplicationRecord
    self.table_name = "analytics.fct_member_activity"

    def readonly?
      true
    end
  end
end
