module HasStreak
  class Streak
    def initialize(instance, association)
      @instance = instance
      @association = association
    end

    def length
      determine_consecutive_days
    end

    private

    attr_reader :association, :instance

    def days
      array = instance.send(association).order("created_at DESC").pluck(:created_at)
      @days ||= array.map { |date| date.in_time_zone(instance.time_zone) }.map(&:to_date).uniq
    end

    def determine_consecutive_days
      streak = first_day_in_collection_is_today? ? 1 : 0
      days.each_with_index do |day, index|
        break unless first_day_in_collection_is_today?
        if days[index+1] == day.yesterday
          streak += 1
        else
          break
        end
      end
      streak
    end

    def first_day_in_collection_is_today?
      days.first == Time.current.in_time_zone(instance.time_zone).to_date
    end
  end
end
