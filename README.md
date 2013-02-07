# Activeadmin::Mongoid::Localize

Easily edit mongoid localized fields in ActiveAdmin (all locales on one page)

## Installation

Add this line to your application's Gemfile:

    gem 'activeadmin-mongoid-localize'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activeadmin-mongoid-localize

## Usage

Really simple:

    f.inputs do
      f.localized_input :title
      
      # and ckeditor too!
      f.localized_input :content, as: :ckeditor
    end

CKEditor is tested with my fork: https://github.com/glebtv/ckeditor

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

This gem uses free flags icons from famfamfam -- http://www.famfamfam.com/lab/icons/flags/

MIT License
