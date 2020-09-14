require 'case_register/version'

module CaseRegister
  def self.included(klass)
    type_hash = {}
    type_counter = 0

    klass.extend(
      Module.new do
        define_method(:case_register_get_method_name){|type| type_hash[type] }
        define_method(:case_register_gen_method_name) do |type|
          id = type_counter += 1
          next (type_hash[type] = :"case_register_auto_method_name#{id}")
        end

        def register_case(type, &block)
          method_name = case_register_gen_method_name(type)
          define_method(method_name, &block)
          private(method_name)
          return method_name
        end
      end
    )
  end

  def invoke_case(type, *args)
    method_name = self.class.case_register_get_method_name(type)

    fail "Undefined case `#{type}` for #{self.class}" if method_name == nil
    return send(method_name, *args)
  end

  def may_invoke_case?(type)
    self.class.case_register_get_method_name(type) != nil
  end
end
