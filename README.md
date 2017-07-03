# Active Support Current Attributes

[![Build Status](https://travis-ci.com/coup-mobility/activesupport-current_attributes.svg?token=BjB77zxGgewb2s2spui7&branch=master)](https://travis-ci.com/coup-mobility/activesupport-current_attributes)

Provides a thread-isolated attributes singleton for Rails applications pre v5.2.0. The singleton is reset automatically before and after reach request. This allows you to keep all the per-request attributes easily available to the whole system.

_**Please note that**: This gem was extracted from this [commit](https://github.com/rails/rails/commit/24a864437e845febe91e3646ca008e8dc7f76b56), which lands in Rails v5.2.0._*

## Installation

Add this line to your application's Gemfile:

```ruby
    gem 'activesupport-current_attributes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activesupport-current_attributes

## Usage

The following full app-like example demonstrates how to use a `Current` class to facilitate easy access to the global, per-request attributes without passing them deeply around everywhere:

```ruby
  # app/models/current.rb
  class Current < ActiveSupport::CurrentAttributes
    attribute :account, :user
    attribute :request_id, :user_agent, :ip_address

    resets { Time.zone = nil }

    def user=(user)
      super
      self.account = user.account
      Time.zone    = user.time_zone
    end
  end

  # app/controllers/concerns/authentication.rb
  module Authentication
    extend ActiveSupport::Concern

    included do
      before_action :authenticate
    end

    private
      def authenticate
        if authenticated_user = User.find(cookies.signed[:user_id])
          Current.user = authenticated_user
        else
          redirect_to new_session_url
        end
      end
  end

  # app/controllers/concerns/set_current_request_details.rb
  module SetCurrentRequestDetails
    extend ActiveSupport::Concern

    included do
      before_action do
        Current.request_id = request.uuid
        Current.user_agent = request.user_agent
        Current.ip_address = request.ip
      end
    end
  end

  # app/controllers/application_controller.rb
  class ApplicationController < ActionController::Base
    include Authentication
    include SetCurrentRequestDetails
  end

  # app/controllers/messages_controller.rb
  class MessagesController < ApplicationController
    def create
      Current.account.messages.create(message_params)
    end
  end

  # app/models/message.rb
  class Message < ApplicationRecord
    belongs_to :creator, default: -> { Current.user }
    after_create { |message| Event.create(record: message) }
  end

  # app/models/event.rb
  class Event < ApplicationRecord
    before_create do
      self.request_id = Current.request_id
      self.user_agent = Current.user_agent
      self.ip_address = Current.ip_address
    end
  end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
