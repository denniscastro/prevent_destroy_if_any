require "prevent_destroy_if_any/version"
I18n.load_path += Dir.glob( File.dirname(__FILE__) + "/locales/*.yml" ) 

class ActiveRecord::Base
  def self.prevent_destroy_if_any(*association_names)
    before_destroy do |model|
      associations_present = []

      association_names.each do |association_name|
        association = model.send association_name
        if association.class == Array
          associations_present << association_name if association.any?
        else
          associations_present << association_name if association
        end
      end

      if associations_present.any?
        errors.add :base, I18n.t('prevent_destroy_if_any', model: model.class.model_name.human.downcase, associations: associations_present.each{|a| a.to_s.classify.constantize.model_name.human.downcase}.to_sentence)
        return false
      end

    end
  end
end
