module CamaleonSpree
  module CamaleonCms
    module FrontendControllerDecorator
      def self.prepended(base)
        base.class_eval do
          # load basic helpers from spree into camaleon frontend
          include Spree::Core::ControllerHelpers::Order
          include Spree::Core::ControllerHelpers::Auth
          include Spree::Core::ControllerHelpers::Store
      
          helper Spree::BaseHelper      
        end
      end
    end
  end
end

::CamaleonCms::FrontendController.prepend(CamaleonSpree::CamaleonCms::FrontendControllerDecorator)