require 'nokogiri'
require 'faraday'
require 'json'

module Mrmanga
  class Parser
    def get_manga(link)
      parsed = parse_link(link)

      noko = Nokogiri::HTML(Faraday.get(link).body)

      metadata = {
        Title: noko.css('h1.names > .name').first.text,
        Author: noko.css('.elem_author > a.person-link').map(&:text).join(', '),
        Keywords: noko.css('.elem_genre > a.element-link').map(&:text).join(', ')
      }

      first_link = noko.css('.read-first > a').attr('href').value

      first_link.sub!(/\?mature=.?/, '')

      noko_first = Nokogiri::HTML(Faraday.get("http://#{parsed[:site]}#{first_link}?mature=1").body)

      volch_with_orig = noko_first.css('#chapterSelectorSelect > option').map { |el| [el.attr('value'), el.text] }

      volch = volch_with_orig.map(&:first)

      regex_volch = /^\/[\w]+\/vol(\d+)\/(\d+).*$/

      volch.map! do |vl|
        match = regex_volch.match vl

        raise "Wrong url: #{vl}" unless match

        match.to_a.drop(1).map(&:to_i)
      end

      volch.reverse!

      orig_names = {}

      volch.each do |item|
        orig_names[item[0]] = {} unless orig_names.key?(item[0])

        orig_names[item[0]][item[1]] = volch_with_orig.pop.last
      end

      manga = Mrmanga::Manga.new

      manga.add_original_chapters(orig_names)
      manga.add_info(
        site: parsed[:site],
        name: parsed[:name]
      )
      manga.add_metadata(metadata)
      manga.add_volumes_and_chapters(volch)

      manga
    end

    def get_chapter_pages(manga, volume, chapter)
      regex = /rm_h.init\( (.*), 0, false\);/

      link = "http://#{manga.info[:info][:site]}/#{manga.info[:info][:name]}/vol#{volume}/#{chapter}?mature=1"

      body = Faraday.get(link).body.tr("'", '"')

      match = regex.match body

      raise "Unmatchable link: #{link}" unless match

      JSON.parse(match[1]).map do |item|
        {
          link: item[1].to_s + item[0].to_s + item[2].to_s,
          width: item[3],
          height: item[4]
        }
      end
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
