module Formtastic
  class FormBuilder
    def localized_input(name, args = {})
      t = self.object.send("#{name}_translations")
      field = ActiveAdmin::Mongoid::Localize::Field.new(self.object, name)

      ret = ''
      self.semantic_fields_for "#{name}_translations", field do |lf|
        ::ActiveAdmin::Mongoid::Localize.locales.each do |locale|
          args[:input_html][:value] =  (t.nil? || t[locale.to_s].nil?) ? '' : t[locale.to_s]
          flag_code = locale.to_s.include?("-") ? locale.to_s.split("-")[1].downcase : locale.to_s

          # stupid fix to be removed
          flag_code = "catalonia" if flag_code == "ca" 

          label = CGI.escapeHTML(self.object.class.human_attribute_name(name)) + " #{template.image_tag "aml/flags/#{flag_code}.png", alt: locale.to_s, title: locale.to_s}"
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
