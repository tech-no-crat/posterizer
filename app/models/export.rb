class Export < ActiveRecord::Base
  attr_accessible :downloads, :generated_at, :path, :status
  belongs_to :user
  validates_presence_of :user
  before_validation :default_values, :on => 'create'

  private
  def default_values
    self.downloads = 0
    self.generated_at = nil
    self.status = "In Queue"
    self.path = nil
  end
end
