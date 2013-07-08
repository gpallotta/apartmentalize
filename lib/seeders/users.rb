module Seeders
  module Users
    class << self

      def seed
        User.destroy_all
        Group.destroy_all
        group = Group.create(identifier: 'TestGroup')
        user_info.each do |arr|
          u = group.users.build(name: arr[0], email: arr[1], password: arr[2],
                            password_confirmation: arr[2])
          u.save
        end

      end

      def user_info
        [
          ['test1', 'test1@test1.com', 'password'],
          ['test2', 'test2@test2.com', 'password'],
          ['test3', 'test3@test3.com', 'password'],
        ]
      end

    end

  end
end
