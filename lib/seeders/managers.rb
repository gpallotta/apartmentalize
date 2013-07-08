module Seeders
  module Managers

    class << self

      def seed
        Manager.delete_all
        Group.all.each do |g|
          g.managers.create(title: 'Landlord',
                            name: 'Mr. Landlord',
                            email: 'landlord@landlord.com',
                            address: "123 Blueberry Lane, Anywhere, USA",
                            phone_number: '1234567890')
          g.managers.create(title: 'Property manager',
                            name: 'Mr Property manager',
                            email: 'pm@pm.com',
                            address: "123 Somewhere Street, Somewhere, USA",
                            phone_number: "0987654321")
        end
      end

    end
  end
end
