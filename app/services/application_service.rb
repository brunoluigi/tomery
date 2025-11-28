# frozen_string_literal: true

# Base class for service objects
# Usage:
#   class MyService < ApplicationService
#     def initialize(user:)
#       @user = user
#     end
#
#     def call
#       # Service logic here
#     end
#   end
#
#   result = MyService.call(user: current_user)
#
class ApplicationService
  def self.call(...)
    new(...).call
  end
end
