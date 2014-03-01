## Rails.aspects

### About


Simple helper that reads attributes assigned to ruby methods, similar to python function decorators.

If you have file called root_controller.rb

	class RootController < ApplicationController
	
	  #= foo: bar
	  #= get
	  def index
	    render template: '/root'
	  end
	end

if you execute
	
	p RootController.aspects 
	
You wil get this hash
	
	{"index":{"get":true,"foo":"bar"}}

### Example 1: Rails rotues

This can be useful if you for example want to have defined routes inside a rails controller, similar like in sinatra.rb

in routes.rb you can define something like this
	
  #= get
  def index
    ...

  #= post
  def action
    ...

  App::Application.routes.draw do
		
		aspect_routes UsersController
		
		...
	

in module app/lib/aspected_routes.db add meanning to aspect_routes method (view source for complete code)

	class ActionDispatch::Routing::Mapper

      def aspect_routes(controller)
	    for key, val in "#{controller.to_s.classify.pluralize}Controller".constantize.aspects
		  if val[:get] && key == 'show'
   	        get "#{controller}/:id" => "#{controller}#show"
	    	  elsif val[:post]
	    	  	...

### Example 2: Wrapper roules for methods

    class UsersApi < DefaultApi

      #= max: 50ms
      #= local
      def index
       render template: '/root'
      end
    end
    
 Can be parsed to
 
 * log all requests that take longer than 50ms to finish
 * allow only local requests to api call
 
 
### Author

Dino Reic / @dux / 2014
 