module Seeders
  module Claims

    class << self

      def seed
        Claim.destroy_all
        u1 = User.find_by_email('test1@test1.com')
        u2 = User.find_by_email('test2@test2.com')
        u3 = User.find_by_email('test3@test3.com')
        create_claim(u1, u2, 40.01, 'May cable', true)
        create_claim(u1, u3, 40.01, 'May cable', true)
        create_claim(u1, u2, 17.51, 'May gas', true)
        create_claim(u1, u3, 17.51, 'May gas', true)
        create_claim(u1, u2, 24.32, 'May electric', true)
        create_claim(u1, u3, 24.32, 'May electric', true)
        create_claim(u1, u2, 40.01, 'June cable', true)
        create_claim(u1, u3, 40.01, 'June cable', true)
        create_claim(u1, u2, 21.97, 'June gas', true)
        create_claim(u1, u3, 21.97, 'June gas', true)
        create_claim(u1, u2, 18.99, 'June electric', true)
        create_claim(u1, u3, 18.99, 'June electric', true)
        create_claim(u1, u2, 40.01, 'July cable')
        create_claim(u1, u3, 40.01, 'July cable')
        create_claim(u1, u2, 15.22, 'July gas')
        create_claim(u1, u3, 15.22, 'July gas')
        create_claim(u1, u2, 29.83, 'July electric')
        create_claim(u1, u3, 29.83, 'July electric')
        create_claim(u2, u1, 5, 'Paper towels')
        create_claim(u2, u3, 5, 'Paper towels')
        create_claim(u2, u1, 3, 'Soap', false, 'Hand/dish soap')
        create_claim(u2, u3, 3, 'Soap', false, 'Hand/dish soap')
        create_claim(u2, u1, 10, 'Fan', false, 'Bought a fan for the house')
        create_claim(u2, u3, 10, 'Fan', false, 'Bought a fan for the house')
        create_claim(u3, u1, 8, 'Zipcar', true, 'Zipcar for grocery shopping')
        create_claim(u3, u2, 8, 'Zipcar', true, 'Zipcar for grocery shopping')
        create_claim(u3, u1, 20, 'Food for July 4th bbq')
        create_claim(u3, u2, 20, 'Food for July 4th bbq')
        create_claim(u3, u1, 3.33, 'trash can', false,
                  'kitchen trash can broke so I bought a new one')
        create_claim(u3, u2, 3.33, 'trash can', false,
                  'kitchen trash can broke so I bought a new one')
        create_claim(u3, u1, 5, 'Various cleaning supplies')
        create_claim(u3, u2, 5, 'Various cleaning supplies')
      end


      def create_claim(user_owed_to, user_who_owes, amount, title,
          paid=false, description='')
        c = Claim.new(title: title, amount: amount, description: description,
                        paid: paid)
        c.user_owed_to = user_owed_to
        c.user_who_owes = user_who_owes
        c.save
      end

    end
  end
end
