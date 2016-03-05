module CallOut
  class Pipeline
    class  RegularFtptVacationFilter < Filter

      def pre_conditions
        [
          ->(filter) { filter.employee.part_time? || filter.employee.full_time? },
          ->(filter) { filter.employee.call_on_vacation? },
          ->(filter) { filter.employee.on_vacation?(start_date, end_date) }
        ]
      end

      def call
        accept! if !on_regularly_scheduled_dates? && employee.call_on_vacation?
      end

      def on_regularly_scheduled_dates?
        (employee.regular_shifts_scheduled_between(start_date, end_date).map(&:date) & shift_dates).present?
      end

    end
  end
end
