module Seeders
  module Chores

    class << self

      def seed
        Chore.destroy_all
        i = 0
        User.all.each do |u|
          group = u.group
          info = chore_info[i]
          c = Chore.new(title: info[0], description: info[1])
          c.group = group
          c.user = u
          c.save
        end
      end

      def chore_info
        [
          ['Clean bathroom', 'Clean toilet, sink, tub'],
          ['Clean kitchen', 'Take out trash, clean floor, counters, stove'],
          ['Clean living room', 'Vacuum floor, dust']
        ]
      end



    end
  end
end
