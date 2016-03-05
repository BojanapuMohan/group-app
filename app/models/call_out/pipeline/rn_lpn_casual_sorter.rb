module CallOut
  class Pipeline
    class RnLpnCasualSorter < Sorter

      attr_accessor :employee_call_outs

      def sorted
        regular_time_call_outs(casual_call_outs) + regular_time_call_outs(part_time_call_outs) + overtime_call_outs(casual_call_outs + part_time_call_outs)
      end

      def casual_call_outs
        employee_call_outs.select {|employee_call_out| employee_call_out.employee.casual? }
      end

      def part_time_call_outs
        employee_call_outs.select {|employee_call_out| employee_call_out.employee.part_time? }
      end

    end
  end
end

