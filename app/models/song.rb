class Song < ActiveRecord::Base

  validates :author, presence: true
  validates :title, presence: true

  def ==(o)
    o.class == self.class && 
      o.author == self.author && 
      o.title == self.title
  end
end
