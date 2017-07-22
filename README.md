# mrmanga

[![Gem Version](https://badge.fury.io/rb/mrmanga.svg)](https://badge.fury.io/rb/mrmanga)
[![Gem](https://img.shields.io/gem/dtv/mrmanga.svg)]()
[![Gemnasium](https://img.shields.io/gemnasium/4ndv/mrmanga.svg)]()

#### Aka mintmanga/readmanga downloader

## Features

* mintmanga and readmanga support
* Automatic PDF creation with correct metadata (Title, Author, Keywords)
* Outlines in PDF (chapters/pages)
* Multithreaded download
* Download only specified volumes

## Linux/Mac Installation

    $ gem install mrmanga

Requires Ruby 2.3+, ImageMagick (or GraphicsMagick), libxml2 (for nokogiri)

## Windows Installation

Download and install ruby 2.4 from here: https://rubyinstaller.org/downloads/

**DONT UNCHECK ANY CHECKBOXES!**

After installation, you will be asked to install devtools, just press enter in this screen and wait.

Download and install ImageMagick from here: http://imagemagick.org/script/download.php

Open CMD and enter this command:

```bash
$ gem install mrmanga --no-ri
```

Now you can use it in any folder where you want to store your downloads, just simply type `mrmanga` in console and follow the instructions.

## Usage

    $ mrmanga

And follow the instructions. By default, it will download to the folder where you runned it.

## Future and TODOs

* EPUB generation (GEPUB) with cover selection
* More usable CLI
* Non-interactive mode

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mrmanga. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
