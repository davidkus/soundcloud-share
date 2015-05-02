module LayoutHelper

  def link_active(controller_name)
    controller.controller_name == controller_name ? "active" : nil
  end

end
