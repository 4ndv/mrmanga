# mrmanga

[![Gem Version](https://badge.fury.io/rb/mrmanga.svg)](https://badge.fury.io/rb/mrmanga)
[![Gem](https://img.shields.io/gem/dt/mrmanga.svg)]()
[![Gemnasium](https://img.shields.io/gemnasium/4ndv/mrmanga.svg)]()

#### Aka mintmanga/readmanga downloader

---------

[Накормить автора кофе или чем-нибудь более интересным](https://andv.xyz/buymeacoffee)

## Фичи

* Скачивание с mintmanga и readmanga
* Автогенерация PDF с корректными метаданными (Название, Автор, Ключевые слова)
* Оглавление в PDF (главы/страницы)
* Многопоточная загрузка
* Загрузка только нужных томов

## Установка на Linux/Mac

    $ gem install mrmanga

Требуется Ruby 2.3+, ImageMagick (или GraphicsMagick), libxml2 (для nokogiri)

## Установка на Windows

Скачайте и установите Ruby 2.4 отсюда: [https://rubyinstaller.org/downloads/](https://rubyinstaller.org/downloads/)

**НЕ УБИРАЙТЕ НИКАКИЕ ГАЛОЧКИ ПРИ УСТАНОВКЕ!**

После установки вылезет окно для установки devtools, просто нажимайте там Enter.

Скачайте и установите GraphicsMagick отсюда: [ftp://ftp.graphicsmagick.org/pub/GraphicsMagick/windows/](ftp://ftp.graphicsmagick.org/pub/GraphicsMagick/windows/)

Откройте cmd и введите эту команду:

```bash
$ gem install mrmanga --no-ri
```

Теперь вы можете использовать команду `mrmanga` в cmd. Просто перейдите в нужную папку (в cmd, командой cd), введите `mrmanga` и следуйте инструкциям.

## Использование

    $ mrmanga

И следуйте инструкциям. По умолчанию, манга будет скачиваться в текущую папку.

## Обновление до новой версии

```bash
$ gem install mrmanga
```

## Future and TODOs

* EPUB generation (GEPUB) with cover selection
* More usable CLI
* Non-interactive mode

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/4ndv/mrmanga. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
