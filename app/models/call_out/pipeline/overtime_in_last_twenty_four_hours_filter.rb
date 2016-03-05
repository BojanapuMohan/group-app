module CallOut
  class Pipeline
    class OvertimeInLastTwentyFourHoursFilter < Filter

      def call
        date_hours.each do |date, hours|
          incurs_overtime! if hours > overtime_limit && date_breaks[date] < 8
        end
      end

      def overtime_limit
        EmployeesRole.food_service_or_cook_roles.include?(employee_role) ? 10.0 : 8.0
      end

      def date_hours
        occurence_calculator.durations_per_day
      end

      def date_breaks
        occurence_calculator.breaks_between_shifts
      end

    end
  end
end
