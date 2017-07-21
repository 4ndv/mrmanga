require 'prawn'
require 'mini_magick'

module Mrmanga
  class PdfRenderer
    def initialize(manga, volume, chapters)
      info = manga.info[:metadata].clone

      title = info[:Title]

      info[:Title] = "#{title} Vol.#{volume}"

      doc = Prawn::Document.new(skip_page_creation: true, info: info)

      outline_map = {}

      total_page_counter = 0

      chapters.each do |ch, pages|
        puts "Chapter #{ch}"

        outline_map[ch] = []

        pages.each do |page|
          doc.start_new_page(margin: 0, size: [page[:width], page[:height]], layout: :portrait)

          outline_map[ch].push(total_page_counter += 1)

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

      doc.outline.define do
        section info[:Title]

        outline_map.each do |chapter, pages|
          section "Chapter #{chapter}", destination: pages.first do
            pages.each do |page_number|
              page title: "Page #{page_number}", destination: page_number
            end
          end
        end
      end

      doc.render_file "#{manga.info[:info][:name]}/#{title} Vol. #{volume}.pdf"
    end
  end
end
