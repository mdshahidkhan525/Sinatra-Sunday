# frozen_string_literal: true

Sequel.seed do
  def run
    # add default admin user
    user = User.new
    user.email = 'test@test.com'
    user.first_name = 'Jae'
    user.last_name = 'Lee'
    user.password_digest = 'asdfasdf'
    user.role = 'admin'
    user.provider = 'email'
    user.save
  end
end
