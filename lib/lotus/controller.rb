require 'lotus/utils/class_attribute'
require 'lotus/action'
require 'lotus/controller/dsl'
require 'lotus/controller/version'
require 'rack-patch'

module Lotus
  # A set of logically grouped actions
  #
  # @since 0.1.0
  #
  # @see Lotus::Action
  #
  # @example
  #   require 'lotus/controller'
  #
  #   class ArticlesController
  #     include Lotus::Controller
  #
  #     action 'Index' do
  #       # ...
  #     end
  #
  #     action 'Show' do
  #       # ...
  #     end
  #   end
  module Controller
    include Utils::ClassAttribute

    # Global handled exceptions.
    # When a handled exception is raised during #call execution, it will be
    # translated into the associated HTTP status.
    #
    # By default there aren't handled exceptions, all the errors are treated
    # as a Server Side Error (500).
    #
    # **Important:** Be sure to set this configuration, **before** the actions
    # and controllers of your application are loaded.
    #
    # @since 0.1.0
    #
    # @see Lotus::Action::Throwable
    #
    # @example
    #   require 'lotus/controller'
    #
    #   Lotus::Controller.handled_exceptions = { RecordNotFound => 404 }
    #
    #   class Show
    #     include Lotus::Action
    #
    #     def call(params)
    #       # ...
    #       raise RecordNotFound.new
    #     end
    #   end
    #
    #   Show.new.call({id: 1}) # => [404, {}, ['Not Found']]
    class_attribute :handled_exceptions
    self.handled_exceptions = {}

    # Global setting for handling exceptions.
    #
    # When an exception is raised during a #call execution it will be
    # translated into an associated HTTP status by default. You may want to
    # disable this behavior for your testes.
    #
    # **Important:** Be sure to set this configuration, **before** the actions
    # and controllers of your application are loaded.
    #
    # @since 0.2.0
    #
    # @see Lotus::Action::Throwable
    #
    # @example
    #   require 'lotus/controller'
    #
    #   Lotus::Controller.handle_exceptions = false
    #
    #   class Show
    #     include Lotus::Action
    #
    #     def call(params)
    #       # ...
    #       raise RecordNotFound.new
    #     end
    #   end
    #
    #   Show.new.call({id: 1}) # => ERROR RecordNotFound: RecordNotFound
    class_attribute :handle_exceptions
    self.handle_exceptions = true

    def self.included(base)
      base.class_eval do
        include Dsl
      end
    end
  end
end

