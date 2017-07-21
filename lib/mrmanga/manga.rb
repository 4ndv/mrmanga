module Mrmanga
  class Manga
    attr_accessor :info

    def initialize
      @info = {}
    end

    def add_info(info)
      @info[:info] = info
    end

    def add_metadata(metadata)
      @info[:metadata] = metadata
    end

    def volumes
      @info[:volch].group_by(&:first)
    end

    def add_volumes_and_chapters(volch)
      @info[:volch] = volch
    end
  end
end
