module CamaleonSpree
  module CamaleonCms
    module UserDecorator
      def self.prepended(base)
        base.class_eval do
          alias_attribute :last_login_at, :last_sign_in_at
          alias_attribute :username, :login
          after_create :check_user_role
      
          has_many :spree_roles, through: :role_users, class_name: 'Spree::Role', source: :role, after_add: :cama_update_roles, after_remove: :cama_update_roles      
        end
      end

      def has_spree_role?(role_in_question)
        spree_roles.any? { |role| role.name == role_in_question.to_s } || self.role == role_in_question.to_s
      end
  
      private
      def check_user_role
        if self.admin?
          Spree::User.find(self.id).spree_roles << Spree::Role.where(name: 'admin').first
        end
      end
  
      def cama_update_roles(role)
        self.update_column(:role, spree_roles.where(spree_roles: {name: 'admin'}).any? ? 'admin' : 'user')
      end
    end
  end
end

::CamaleonCms::User.prepend(CamaleonSpree::CamaleonCms::UserDecorator)
