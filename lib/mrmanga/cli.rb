module Mrmanga
  class CLI
    def interactive_shell
      require 'highline/import'

      say "Welcome to mrmanga #{Mrmanga::VERSION}!"

      say 'It will create folders into CURRENT PATH!!'

      regex = /http(s?):\/\/(readmanga.me|mintmanga.com)\/([\w]+)(\/?)/

      link = ask 'Tell me the link of the manga you want to download (example: http://readmanga.me/your_name)?  ' do |q|
        q.validate = regex
      end

      create_pdfs = agree 'Create pdfs for volumes? (Y/n)'

      say "Parsing manga info"

      manga = Mrmanga::Parser.new.get_manga(link)

      say "Parsed, downloading"

      dl = Mrmanga::Downloader.new(manga)

      manga.volumes.each do |vol, _|
        puts "Downloading volume #{vol}"

        volume = dl.download_volume(vol)

        puts volume
      end
    end
  end
end
