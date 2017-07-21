require 'prawn'
require 'mini_magick'

module Mrmanga
  class PdfRenderer
    def initialize(manga, volume, chapters)
      info = manga.info[:metadata].clone

      info[:Title] = "#{info[:Title]} Vol.#{volume}"

      doc = Prawn::Document.new(skip_page_creation: true, info: info)

      chapters.each do |ch, pages|
        puts "Chapter #{ch}"

        pages.each do |page|
          doc.start_new_page(margin: 0, size: [page[:width], page[:height]], layout: :portrait)

          begin
            doc.image(page[:file])
          rescue Prawn::Errors::UnsupportedImageType
            # Some pdfs may fail, so we convert them to jpg
            puts "Error in image #{page[:file]}, force converting to jpg and writing jpg version"
            conv = MiniMagick::Image.open(page[:file])

            conv.format 'jpg'
            conv.quality 100

            doc.image(conv.path)
          end
        end
      end

      doc.render_file "#{manga.info[:info][:name]}/vol#{volume}.pdf"
    end
  end
end
