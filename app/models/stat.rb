class Stat < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    [ "username" ]
  end

  def readonly?
    true
  end
end
