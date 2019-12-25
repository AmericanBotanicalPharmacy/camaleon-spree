class CamaleonSpree::ProductDecorator < CamaleonCms::ApplicationDecorator
  include CamaleonCms::CustomFieldsConcern
  delegate_all
end
