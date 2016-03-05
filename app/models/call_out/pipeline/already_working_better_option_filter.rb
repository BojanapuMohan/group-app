module CallOut
  class Pipeline
    class  AlreadyWorkingBetterOptionFilter < Filter

      def pre_conditions
        [
          ->(filter) { filter.rejected? },
          ->(filter) { filter.starts_at >= Time.now + 14.days },
          ->(filter) { filter.working_casual_shift_on_any_call_out_dates? }
        ]
      end

      def call
        casual_shifts_on_call_out_dates.each do |casual_shift|
          accept! if casual_shift.length + 5 <= call_out_shift.length
        end
      end

      def working_casual_shift_on_any_call_out_dates?
        casual_shifts_on_call_out_dates.present?
      end

      def casual_shifts_on_call_out_dates
        @casual_shifts_on_call_out_dates ||= employee.shifts_worked_between(start_date, end_date)
                                .select {|occurrence| shift_dates.include? occurrence.date}
                                .select {|occurrence| occurrence.casual_shift?(employee)}
                                .map(&:employee_shift).uniq
      end

    end
  end
end
