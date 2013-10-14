require_relative 'helpers'

module EnterpriseChef

  # Allows us to use various helper methods directly in recipes,
  # resources, and providers without a lot of ceremony.
  #
  # Thus, instead of something like
  #
  #   if Foo::Bar.is_awesome?(node)
  #     include_recipe "awesome::default"
  #   end
  #
  # we can do this:
  #
  #   if is_awesome?
  #     include_recipe "awesome::default"
  #   end
  #
  module DSL

    EnterpriseChef::Helpers.singleton_class.instance_methods(false).each do |name|
      define_method(name) do
        EnterpriseChef::Helpers.send(name, node)
      end
    end

  end
end

Chef::Recipe.send(:include, EnterpriseChef::DSL)
Chef::Provider.send(:include, EnterpriseChef::DSL)
Chef::Resource.send(:include, EnterpriseChef::DSL)
