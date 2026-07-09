module Analytics
  class DimMember < ApplicationRecord
    self.table_name = "analytics.dim_member"
    self.primary_key = "user_id"

    def readonly?
      true
    end
  end
end
