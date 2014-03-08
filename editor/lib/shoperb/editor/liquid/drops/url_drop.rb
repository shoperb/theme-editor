module UrlDrop
  # paths to generate links
  class Get< Liquid::Drop
    def products;
      gen_path;
    end


    def cart;
      gen_path;
    end


    def login;
      gen_path;
    end


    def logout;
      gen_path;
    end


    def orders;
      gen_path;
    end


    private
    def controller
      @context.registers[:controller]
    end

    def gen_path
      called_by = caller_locations(1,1)[0].label
      controller.send("store_#{called_by}_path")
    end
  end


  # Paths to generate form actions
  class Post < Liquid::Drop
    def cart_add
      controller.send("add_store_cart_path")
    end

    def cart_checkout
      controller.send("checkout_store_cart_path")
    end

    def cart_update
      controller.send("update_store_cart_path")
    end


    def new_login
      controller.send("store_new_login_path")
    end


    def auth_input
      name  = controller.send(:request_forgery_protection_token).to_s
      value = controller.send(:form_authenticity_token)

      %(<input type="hidden" name="#{name}" value="#{value}">)
    end


    private
    def controller
      @context.registers[:controller]
    end
  end
end