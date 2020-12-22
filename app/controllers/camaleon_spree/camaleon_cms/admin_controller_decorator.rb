module CamaleonSpree
  module CamaleonCms
    module AdminControllerDecorator
      def self.prepended(base)
        base.class_eval do
          # before_action :set_spree_buttons
          helper_method :current_store
        end
      end

      def current_store
        Spree::Store.current
      end

      private
      def set_spree_buttons
        return if cannot? :manage, :spree_role
        cama_content_prepend("
        <div id=\"tmp_spree_menu\" style=\"display: none\"> #{render_to_string partial: 'spree/admin/shared/main_menu'} </div>
        <script>
        jQuery(function(){
            // spree commerce menus
            $('#sidebar-menu .sidebar-menu').append('<li id=\"spree_commerce_menu\" class=\"treeview\" data-key=\"settings\"> <a href=\"#\"><i class=\"fa fa-shopping-cart\"></i> <span class="">#{t('plugins.spree_cama.admin.menus.ecommerce', default: 'Spree Ecommerce')}</span> <i class=\"fa fa-angle-left pull-right\"></i></a> <ul class=\"treeview-menu\"></ul> </li>');
            var items = $('#tmp_spree_menu').find('.nav-sidebar > .sidebar-menu-item').clone();
            items.find('ul').attr('class', 'treeview-menu').each(function(){ $(this).prev().removeAttr('data-toggle').removeAttr('aria-expanded').append('<i class=\"fa fa-angle-left pull-right\"></i>'); });
            items.find('a').prepend('<i class=\"fa fa-circle-o\"></i>');
            $('#spree_commerce_menu .treeview-menu').html(items);

            // menu spree as iframe
            function spree_load_iframe(url){
                $('#admin_content').html('<iframe style=\"width: 100%; height: 480px; margin-top: -66px;\" frameBorder=\"0\" src=\"'+url+'\">').find('iframe').load(function(){
                    $(this.contentWindow.document.body).css({'padding-bottom': '120px', 'min-height': '500px'});
                    this.style.height = this.contentWindow.document.body.offsetHeight + 15 + 'px';
                    if('history' in window && 'pushState' in history) window.history.pushState({}, '', '#{cama_admin_dashboard_path}?cama_spree_iframe_path='+this.contentWindow.location.href);
                });
            }

            $('#spree_commerce_menu li[data-spree-ecommerce] a, #spree_commerce_menu a').click(function(e){
                if($(this).attr('href').search('#') == 0) return e.preventDefault();
                $(this).closest('li').addClass('active').siblings().removeClass('active');
                spree_load_iframe($(this).attr('href'));
                window.scrollTo(0, 0);
                return false;
            });
            #{"spree_load_iframe('#{params[:cama_spree_iframe_path]}'); $('#spree_commerce_menu > a').click();" if params[:cama_spree_iframe_path].present?}
        }); </script>")
      end

    end
  end
end

::CamaleonCms::FrontendController.prepend(CamaleonSpree::CamaleonCms::AdminControllerDecorator)