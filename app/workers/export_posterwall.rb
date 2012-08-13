class ExportPosterwall
  include Sidekiq::Worker

  @@files_path = Rails.root + '/files'

  def perform(user_id, x, y)
    x ||= 800
    y ||= 600

    user = User.find(user_id)
    pwidth = user.poster_width
    pheight = (poster_width * 1.5).floor
    posters = user.posters.shuffle

    

  end
end
