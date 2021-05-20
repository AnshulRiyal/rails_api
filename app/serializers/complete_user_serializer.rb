class CompleteUserSerializer < ActiveModel::Serializer
  attributes :name, :email, :contact
  has_many :articles
end