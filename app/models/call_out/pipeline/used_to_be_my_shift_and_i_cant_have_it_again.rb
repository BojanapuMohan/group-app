module CallOut
  class Pipeline
    class  UsedToBeMyShiftAndICantHaveItAgain < Filter

      def call
        reject! if have_had_this_shift_in_the_past?
      end

      def have_had_this_shift_in_the_past?
        (employee.employee_shifts & employee_shifts).present?
      end

      def employee_shifts
        pipeline.shift.employee_shifts.between(start_date, end_date)
      end
    end
  end
end
