require 'nokogiri'
require 'faraday'

module Mrmanga
  class Parser
    def get_manga(link)
      parsed = parse_link(link)

      noko = Nokogiri::HTML(Faraday.get(link).body)

      item = noko.css('div[itemtype="http://schema.org/CreativeWork"]')

      metadata = {
        Title: noko.css('h1.names > .name').first.text,
        Author: noko.css('.elem_author > a.person-link').map(&:text).join(', '),
        Keywords: noko.css('.elem_genre > a.element-link').map(&:text).join(', ')
      }

      first_link = noko.css('.read-first > a').attr('href').value

      first_link.sub!(/\?mature=.?/, '')

      noko_first = Nokogiri::HTML(Faraday.get("http://#{parsed[:site]}#{first_link}?mature=1").body)

      volch = noko_first.css('#chapterSelectorSelect > option').map { |el| el.attr('value') }

      regex_volch = /^\/[\w]+\/vol(\d+)\/(\d+).*$/

      volch.map! do |vl|
        match = regex_volch.match vl

        raise "Wrong url: #{vl}" unless match

        match.to_a.drop(1)
      end

      volch.reverse!

      manga = Mrmanga::Manga.new

      manga.add_metadata(metadata)
      manga.add_volumes_and_chapters(volch)

      manga
    end

    private

    def parse_link(link)
      regex = /http(s?):\/\/(readmanga.me|mintmanga.com)\/([\w]+)(\/?)/

      match = regex.match(link)

      raise 'Incorrect link' unless match

      {
        site: match[2],
        name: match[3]
      }
    end
  end
end
