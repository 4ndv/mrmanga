module Mrmanga
  class CLI
    def parse_volumes_range(string)
      return 'all' if string == 'all'

      if /^\d+-\d+$/ =~ string
        # 13-37 syntax
        a = string.split('-')
        return (a[0]..a[1]).to_a
      end

      string.tr(' ', '').split(',').map(&:to_i)
    end

    def interactive_shell
      require 'highline/import'

      say "Welcome to mrmanga #{Mrmanga::VERSION}!"

      say 'It will create folders into CURRENT PATH!!'

      regex = /http(s?):\/\/(readmanga.me|mintmanga.com)\/([\w]+)(\/?)/

      link = ask 'Tell me the link of the manga you want to download (example: http://readmanga.me/your_name)?  ' do |q|
        q.validate = regex
      end

      # TODO: Ask for volumes to download

      puts "Just press Enter to download all the volumes, or specity volumes using this: 1-5 or this: 1, 2, 3, 4, 5 (or 1,2,3,4,5) syntaxes. Also you can download one volume by entering it's number (like this: 1)"

      volumes = ask('Which volumes should i download?  ') { |q| q.default = 'all' }

      volumes = parse_volumes_range(volumes)

      puts "Will download these volumes: #{volumes.join(', ')}" if volumes != 'all'

      downloader_settings = {
        threads: ask('How many threads should i use to download? (6)  ', Integer) { |q| q.default = 6 },
        volumes: volumes
      }

      create_pdfs = agree('Create pdfs for volumes?') { |q| q.default = 'yes' }

      pdf_settings = {
        disable_outline_pages: false
      }

      if create_pdfs
        pdf_settings[:disable_outline_pages] = !agree('Add pages in PDF outline?') { |q| q.default = 'no' }
      end

      say 'Parsing manga info'

      manga = Mrmanga::Parser.new.get_manga(link)

      say 'Parsed, downloading'

      dl = Mrmanga::Downloader.new(manga, downloader_settings)

      manga.volumes.each do |vol, _|
        volume = dl.download_volume(vol)

        if create_pdfs && volume
          puts "Rendering pdf of Vol.#{volume[:volume]}"
          Mrmanga::PdfRenderer.new(manga, volume[:volume], volume[:pages], pdf_settings)
        end
      end
    end
  end
end
