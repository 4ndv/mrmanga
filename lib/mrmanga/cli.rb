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

      puts link
      puts create_pdfs
    end
  end
end
