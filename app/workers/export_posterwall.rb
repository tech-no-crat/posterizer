
class ExportPosterwall
  include Sidekiq::Worker
  include Magick

  @@files_path = Rails.root.to_s + '/files/'

  def perform(export_id, width, height)
    width ||= 800
    height ||= 600
    status = "Being processed"

    export = Export.find(export_id)
    export.status = status
    export.save
    status = "Failed"

    user = export.user
    posters = user.posters.map { |p| p.movie }
    path = "/posterwalls/#{export.id}.jpg"

    poster_width = user.poster_width
    poster_height = (poster_width * 1.5).floor
    columns = (width/poster_width).ceil
    rows = (height/poster_height).ceil

    filenames = []
    posters.each do |p|
      f = @@files_path + "posters/#{p.id}.jpg"
      #UNSAFE:
      `curl -o "#{f}" "#{p.url}"` unless File.exists?(f)
      filenames << f
    end

    files = []
    files.concat filenames.shuffle until files.length > (rows * columns)

    puts "Files: #{files.join(" -> ")}"

    result = ImageList.new
    1.upto(rows) do |x|
      col = ImageList.new
      puts "Starting column"
      1.upto(columns) do |y|
        puts "s: #{files[(y-1) + (x-1) * columns]}"
        col.push(Image.read(files[(y-1) + (x-1) * columns]).first.resize_to_fill(poster_width, poster_height))
        puts "e"
      end
      puts "Column done"
      result.push(col.append(false))
    end
    result.append(true).write(Rails.root.to_s + "/public" + path)

    status = "Completed"
    export.path = path
    export.status = status
    export.save
  ensure
    puts "Done"
    if export and export.status != status
      export.status = status
      export.save
    end
  end
end
