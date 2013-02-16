module Formtastic
  class FormBuilder
    def localized_input(name, args = {})
      t = self.object.send("#{name}_translations")
      field = ActiveAdmin::Mongoid::Localize::Field.new(self.object, name)

      ret = ''
      self.semantic_fields_for "#{name}_translations", field do |lf|
        ::I18n.available_locales.each do |locale|
          args[:value] =  (t.nil? || t[locale.to_s].nil?) ? '' : t[locale.to_s]

          label = CGI.escapeHTML(self.object.class.human_attribute_name(name)) + " #{template.image_tag "aml/flags/#{locale.to_s}.png", alt: locale.to_s, title: locale.to_s}"
          if args[:as] == :ckeditor
            prepend = "<h3 style='margin: 10px 0px 0px 10px;'>#{label}</h3>#{'<abbr>*</abbr>' if field.required?}".html_safe
            args[:label] = false
          else
            prepend = ''.html_safe
            args[:label] = label.html_safe
          end
          args[:required] = field.required?

          ret << prepend + lf.input(locale, args)
        end
      end

      ret.html_safe
    end
  end
end
