require 'case_register/version'

module CaseRegister
  def self.included(klass)
    type_hash = {}
    type_counter = 0

    get_method_name = proc do |type|
      next nil if type_hash == nil
      next type_hash[type]
    end

    gen_method_name = proc do |type|
      id = type_counter += 1
      next (type_hash[type] = :"case_register_auto_method_name#{id}")
    end

    klass.extend(
      Module.new do
        define_method(:case_register_get_method_name){|type| get_method_name[type] }
        define_method(:case_register_gen_method_name){|type| gen_method_name[type] }

        def register_case(type, &block)
          method_name = case_register_gen_method_name(type)
          define_method(method_name, &block)
          private(method_name)
          return method_name
        end
      end
    )
  end

  def load_registered_case(type, *args)
    send(self.class.case_register_get_method_name(type), *args)
  end

  def may_load_registered_case?(type)
    self.class.case_register_get_method_name(type) != nil
  end
end
