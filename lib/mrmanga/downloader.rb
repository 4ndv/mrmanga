require 'down'
require 'fileutils'
require 'parallel'
require 'progressbar'

module Mrmanga
  class Downloader
    def initialize(manga, settings)
      @manga = manga

      @settings = settings

      @name = @manga.info[:info][:name]

      if File.directory?(@name)
        should_continue = agree("Folder '#{@name}' already exists, continue?") { |q| q.default = 'yes' }

        return unless should_continue
      end
    end

    def download_volume(volume)
      if @settings[:volumes] != 'all'
        unless @settings[:volumes].include?(volume.to_s)
          puts "Skipping Vol. #{volume}"
          return false
        end
      end

      puts "Downloading volume #{volume}"

      prefix = "#{@name}/vol#{volume}"

      parser = Mrmanga::Parser.new

      FileUtils.mkdir_p(prefix)

      downloaded = {}

      @manga.volumes[volume].each do |volch|
        pages = parser.get_chapter_pages(@manga, volch[0], volch[1])

        progress = ProgressBar.create(title: "Downloading vol.#{volch[0]} ch.#{volch[1]}", total: pages.count)

        Parallel.each_with_index(pages, in_threads: @settings[:threads]) do |page, index|
          progress.increment

          timeout_retries = 0

          begin
            temp = Down.download(page[:link], open_timeout: 20, read_timeout: 20, 'Referer' => @manga.info[:info][:site])
          rescue Down::TimeoutError
            retry if timeout_retries += 1 < 15

            puts 'TimeoutError after many retries, debug info:'

            puts page[:link]
            puts @manga.info[:info]
            puts volch.inspect
            puts "Page number: #{index + 1}"
            puts @settings

            raise
          rescue
            puts 'Debug info:'

            puts page[:link]
            puts @manga.info[:info]
            puts volch.inspect
            puts "Page number: #{index + 1}"
            puts @settings

            raise
          end

          temp.close # Windows needs this

          ext = File.extname(temp.path)

          new_path = File.join(prefix, "#{volch[0]} - #{volch[1]} - #{index + 1}#{ext}")

          FileUtils.mv temp.path, new_path

          page[:file] = new_path
        end

        downloaded[volch[1]] = pages

        progress.finish
      end

      {
        volume: volume,
        pages: downloaded
      }
    end
  end
end
