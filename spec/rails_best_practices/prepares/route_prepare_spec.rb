require 'spec_helper'

describe RailsBestPractices::Prepares::RoutePrepare do
  let(:runner) { RailsBestPractices::Core::Runner.new(:prepares => RailsBestPractices::Prepares::RoutePrepare.new) }

  context "rails2" do
    context "resources" do
      it "should add resources route" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.resources :posts
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 7
        routes.map(&:to_s).should == ["PostsController#index", "PostsController#show", "PostsController#new", "PostsController#create", "PostsController#edit", "PostsController#update", "PostsController#destroy"]
      end

      it "should add multiple resources route" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.resources :posts, :users
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 14
      end

      it "should add resources route with only option" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.resources :posts, :only => [:index, :show, :new, :create]
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 4
        routes.map(&:to_s).should == ["PostsController#index", "PostsController#show", "PostsController#new", "PostsController#create"]
      end

      it "should add resources route with except option" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.resources :posts, :except => [:edit, :update, :destroy]
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 4
        routes.map(&:to_s).should == ["PostsController#index", "PostsController#show", "PostsController#new", "PostsController#create"]
      end

      it "should not add resources routes with :only => :none" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.resources :posts, :only => :none
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 0
      end

      it "should not add resources routes with :except => :all" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.resources :posts, :except => :all
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 0
      end

      it "should add resource routes with get/post/put/delete routes" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.resources :posts, :only => [:show], :collection => { :list => :get }, :member => { :create => :post, :update => :put, :destroy => :delete }
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 5
        routes.map(&:to_s).should == ["PostsController#show", "PostsController#create", "PostsController#update", "PostsController#destroy", "PostsController#list"]
      end

      it "should add route with nested routes" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.resources :posts do |post|
            post.resources :comments
          end
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 14
      end

      it "should add rout with namespace" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.namespace :admin do |admin|
            admin.namespace :test do |test|
              test.resources :posts, :only => [:index]
            end
          end
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.map(&:to_s).should == ["Admin::Test::PostsController#index"]
      end
    end

    context "resource" do
      it "should add resource route" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.resource :posts
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 6
        routes.map(&:to_s).should == ["PostsController#show", "PostsController#new", "PostsController#create", "PostsController#edit", "PostsController#update", "PostsController#destroy"]
      end

      it "should add multiple resource route" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.resource :posts, :users
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 12
      end

      it "should add resource route with only option" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.resource :posts, :only => [:show, :new, :create]
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 3
        routes.map(&:to_s).should == ["PostsController#show", "PostsController#new", "PostsController#create"]
      end

      it "should add resource route with except option" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.resource :posts, :except => [:edit, :update, :destroy]
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 3
        routes.map(&:to_s).should == ["PostsController#show", "PostsController#new", "PostsController#create"]
      end

      it "should not add resource routes with :only => :none" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.resource :posts, :only => :none
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 0
      end

      it "should not add resource routes with :except => :all" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.resource :posts, :except => :all
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 0
      end
    end

    it "should add connect route" do
      content =<<-EOF
      ActionController::Routing::Routes.draw do |map|
        map.connect 'vote', :controller => "votes", :action => "create", :method => :post
      end
      EOF
      runner.prepare('config/routes.rb', content)
      routes = RailsBestPractices::Prepares.routes
      routes.map(&:to_s).should == ["VotesController#create"]
    end

    it "should add named route" do
      content =<<-EOF
      ActionController::Routing::Routes.draw do |map|
        map.login '/player/login', :controller => 'sessions', :action => 'new', :conditions => { :method => :get }
      end
      EOF
      runner.prepare('config/routes.rb', content)
      routes = RailsBestPractices::Prepares.routes
      routes.map(&:to_s).should == ["SessionsController#new"]
    end
  end

  context "rails3" do
    context "resources" do
      it "should add resources route" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          resources :posts
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 7
        routes.map(&:to_s).should == ["PostsController#index", "PostsController#show", "PostsController#new", "PostsController#create", "PostsController#edit", "PostsController#update", "PostsController#destroy"]
      end

      it "should add multiple resources route" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          resources :posts, :users
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 14
      end

      it "should add resources route with only option" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          resources :posts, :only => [:index, :show, :new, :create]
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 4
        routes.map(&:to_s).should == ["PostsController#index", "PostsController#show", "PostsController#new", "PostsController#create"]
      end

      it "should add resources route with except option" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          resources :posts, :except => [:edit, :update, :destroy]
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 4
        routes.map(&:to_s).should == ["PostsController#index", "PostsController#show", "PostsController#new", "PostsController#create"]
      end

      it "should not add resources routes with :only => :none" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          resources :posts, :only => :none
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 0
      end

      it "should not add resources routes with :except => :all" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          resources :posts, :except => :all
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 0
      end

      it "should add connect route" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.connect 'vote', :controller => "votes", :action => "create", :method => :post
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.map(&:to_s).should == ["VotesController#create"]
      end

      it "should add named route" do
        content =<<-EOF
        ActionController::Routing::Routes.draw do |map|
          map.login '/player/login', :controller => 'sessions', :action => 'new', :conditions => { :method => :get }
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.map(&:to_s).should == ["SessionsController#new"]
      end
    end

    context "resource" do
      it "should add resource route" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          resource :posts
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 6
        routes.map(&:to_s).should == ["PostsController#show", "PostsController#new", "PostsController#create", "PostsController#edit", "PostsController#update", "PostsController#destroy"]
      end

      it "should add multiple resource route" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          resource :posts, :users
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 12
      end

      it "should add resource route with only option" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          resource :posts, :only => [:show, :new, :create]
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 3
        routes.map(&:to_s).should == ["PostsController#show", "PostsController#new", "PostsController#create"]
      end

      it "should add resource route with except option" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          resource :posts, :except => [:edit, :update, :destroy]
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 3
        routes.map(&:to_s).should == ["PostsController#show", "PostsController#new", "PostsController#create"]
      end

      it "should not add resource routes with :only => :none" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          resource :posts, :only => :none
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 0
      end

      it "should not add resource routes with :except => :all" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          resource :posts, :except => :all
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 0
      end

      it "should add resource routes with get/post/put/delete routes" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          resources :posts, :only => [:show] do
            get :list, :on => :collection
            post :create, :on => :member
            put :update, :on => :member
            delete :destroy, :on => :memeber
          end
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 5
        routes.map(&:to_s).should == ["PostsController#show", "PostsController#list", "PostsController#create", "PostsController#update", "PostsController#destroy"]
      end

      it "should add route with nested routes" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          resources :posts
            resources :comments
          end
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.size.should == 14
      end

      it "should add rout with namespace" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          namespace :admin do
            namespace :test do
              resources :posts, :only => [:index]
            end
          end
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.map(&:to_s).should == ["Admin::Test::PostsController#index"]
      end

      it "should add match route" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          match '/auth/:provider/callback' => 'authentications#create'
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.map(&:to_s).should == ["AuthenticationsController#create"]
      end

      it "should add root route" do
        content =<<-EOF
        RailsBestPracticesCom::Application.routes.draw do
          root :to => 'home#index'
        end
        EOF
        runner.prepare('config/routes.rb', content)
        routes = RailsBestPractices::Prepares.routes
        routes.map(&:to_s).should == ["HomeController#index"]
      end
    end
  end
end
