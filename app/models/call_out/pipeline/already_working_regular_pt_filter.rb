module CallOut
  class Pipeline
    class AlreadyWorkingRegularPtFilter < Filter

      def call
        accept! if working_regular_shift_on_any_call_out_dates?
      end

      def pre_conditions
        [
          ->(filter) { filter.rejected? },
          ->(filter) { filter.call_out_shift.length >= 5 },
          ->(filter) { filter.employee.part_time? }
        ]
      end

      def working_regular_shift_on_any_call_out_dates?
        employee.shifts_scheduled_between(start_date, end_date)
          .select {|occurrence| shift_dates.include? occurrence.date}
          .map {|occurrence| occurrence.regularly_scheduled_shift?(employee)}.any?
      end

    end
  end
end
