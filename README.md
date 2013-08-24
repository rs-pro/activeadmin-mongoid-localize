# Activeadmin::Mongoid::Localize

Easily edit mongoid localized fields in ActiveAdmin (all locales on one page)

## Screenshot

 ![AML](http://rscx.ru/aml.jpg)

## Installation

Add this line to your application's Gemfile:

    gem 'activeadmin-mongoid-localize'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activeadmin-mongoid-localize

## Usage

Really simple:

    # in model
    field :title, type: String, localize: true
    field :content, type: String, localize: true

    # in admin
    f.inputs do
      f.localized_input :title
      
      # and ckeditor too!
      f.localized_input :content, as: :ckeditor
    end

    # displaying in index action
    index do
      localize_column :title
    end

    # displaying in show action
    show do |f|
        panel I18n.t('fields') do
            localize_attributes_table_for f do
                row :name
                row :text
            end
        end
    end


## Configuration

By default this gem provides editable fields for all the available locales. If however, you would want to restrict to some particular locales, then create a new *'active_admin_mongoid_localize.rb'* file in the *'/config/initializers'* folder of your rails application:


    ActiveAdmin::Mongoid::Localize.configure do |config|

      config.locales = [:en, :ja]    # Specify the locales you want to use

    end



CKEditor is tested & working with my fork: https://github.com/glebtv/ckeditor

ActiveAdmin-mongoid is tested & working with my fork: https://github.com/rs-pro/activeadmin-mongoid

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

This gem uses free flags icons from famfamfam -- http://www.famfamfam.com/lab/icons/flags/

MIT License
