require 'down'
require 'fileutils'
require 'parallel'

module Mrmanga
  class Downloader
    def initialize(manga)
      @manga = manga

      @name = @manga.info[:info][:name]

      raise "Folder '#{@name}' already exists" if File.directory?(@name)
    end

    def download_volume(volume)
      prefix = "#{@name}/vol#{volume}"

      parser = Mrmanga::Parser.new

      FileUtils.mkdir_p(prefix)

      downloaded = {}

      @manga.volumes[volume].each do |volch|
        puts "Downloading vol.#{volch[0]} ch.#{volch[1]}"
        pages = parser.get_chapter_pages(@manga, volch[0], volch[1])

        Parallel.each_with_index(pages, in_threads: 4) do |page, index|
          puts "Downloading page #{index + 1}"

          temp = Down.download(page[:link], open_timeout: 20, read_timeout: 20)
          ext = File.extname(temp.path)

          new_path = File.join(prefix, "#{volch[0]} - #{volch[1]} - #{index + 1}#{ext}")

          FileUtils.mv temp.path, new_path

          page[:file] = new_path
        end

        downloaded[volch[1]] = pages
      end

      {
        volume: volume,
        pages: downloaded
      }
    end
  end
end
