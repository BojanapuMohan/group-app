module CallOut
  class Pipeline
    class SharedDutyShiftSorter < Sorter

      attr_accessor :employee_call_outs

      def sorted
        regular_time_call_outs(housekeeper_call_outs) + regular_time_call_outs(other_call_outs) + overtime_call_outs(housekeeper_call_outs) + overtime_call_outs(other_call_outs)
      end

      def housekeeper_call_outs
        @housekeeper_call_outs ||= employee_call_outs.select {|employee_call_out| employee_call_out.employee_roles.include?(EmployeesRole.housekeeper) }.sort_by {|employee_call_out| employee_call_out.employee_seniority }.reverse
      end

      def other_call_outs
        employee_call_outs - housekeeper_call_outs
      end

    end
  end
end

