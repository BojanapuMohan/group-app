module CallOut
  class Pipeline
    class  OvertimeConsecutiveDaysRnAndLpnFilter < Filter

      def pre_conditions
        [
          ->(filter) { EmployeesRole.rn_or_lnp_roles.include?(filter.employee_role)}
        ]
      end

      def call
        six_day_blocks.each do |six_day_block|
          incurs_overtime! if six_day_block.compact.size > 5
        end
      end

      def six_day_blocks
        occurence_calculator + (employee.shifts_worked_between(start_date - 6, end_date + 6) - overlapping_occurences )
        (start_date - 6..end_date + 6).each_cons(6).map {|six_day_block| six_day_block.map {|date| occurence_calculator.shift_on(date) } }
      end

    end
  end
end
