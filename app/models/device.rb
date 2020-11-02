class Device < ApplicationRecord
  belongs_to :company
  self.inheritance_column = :_type_disabled
end
