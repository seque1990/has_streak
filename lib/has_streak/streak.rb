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
      @days ||= instance.send(association).order("created_at DESC").pluck(:created_at).map(&:to_date).uniq
    end

    def determine_consecutive_days
      if first_day_in_collection_is_today? || first_day_in_collection_is_yesterday?
        streak = check_streak(1)
      else
        streak = 0
      end
      streak
    end

    def check_streak(streak)
      streak_count = streak
      days.each_with_index do |day, index|
        if days[index+1] == day.yesterday
          streak_count += 1
        else
          break
        end
      end
      streak_count
    end

    def first_day_in_collection_is_today?
      days.first == Time.current.in_time_zone(instance.time_zone).to_date
    end

    def first_day_in_collection_is_yesterday?
      days.first == Time.current.in_time_zone(instance.time_zone).to_date.yesterday
    end
  end
end
