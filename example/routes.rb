#!/usr/bin/ruby

require 'aspect'

# class RootController < ApplicationController

#   #= foo: bar
#   #= get
#   def index
#     render template: '/root'
#   end
# end

# RootController.aspects 
# {"index":{"get":true,"foo":"bar"}}

class ActionDispatch::Routing::Mapper

  # in routes.rb
  # aspect_routes :restaurants, :r # /r/14 => 'restaurants#show'
  # aspect_routes :restaurants
  def aspect_routes(controller, base_route=nil)
    base_route ||= controller
    for key, val in "#{controller.to_s.classify.pluralize}Controller".constantize.aspects

      # map only get routes
      next unless val[:get]

      case key.to_sym
        when :index
          get base_route.to_s => "#{controller}#index"
        when :show
          get "#{base_route}/:id" => "#{controller}#show"
        else
          route_path = val[:collection] ? "#{base_route}#{key}" : "#{base_route}/:id/#{key}"
          get route_path => "#{controller}##{key}"
      end

    end
  end
end