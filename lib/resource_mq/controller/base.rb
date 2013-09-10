module ResourceMQ
  module Controller
    class Base
      MODULES = [
          Metal,
          Callbacks,
          Responder
      ]

      MODULES.each do |mod|
        include mod
      end
    end
  end
end
