module CallOut
  class Pipeline
    class  OvertimeOneWeekFilter < Filter

      def call
        incurs_overtime! if overtime_in_any_week?
      end

      def overtime_in_any_week?
        occurence_calculator.durations_per_week.map {|week, hours| hours > overtime_limit}.any?
      end

      def overtime_limit
        40
      end
    end
  end
end
