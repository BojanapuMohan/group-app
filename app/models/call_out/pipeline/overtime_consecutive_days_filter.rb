module CallOut
  class Pipeline
    class  OvertimeConsecutiveDaysFilter < Filter

      def pre_conditions
        [
          ->(filter) { !filter.employee.casual? },
          ->(filter) { !EmployeesRole.rn_or_lnp_roles.include?(filter.employee_role)}
        ]
      end

      def call
        breaks_in_eight_day_blocks.each do |eight_day_block_with_breaks|
         incurs_overtime! unless eight_day_block_with_breaks.any?
        end
      end

      #Mark the employee as eligible for overtime if the employee does not have 2 consecutive days off in the 8 day period before or after each day of the block.

      def eight_day_blocks_with_consecutive_days
        occurence_calculator + employee.shifts_worked_between(start_date - 8, end_date + 8)
        (start_date - 8..end_date + 8).each_cons(8).map {|eight_day_block| eight_day_block.each_cons(2).to_a.map {|two_day_block| two_day_block.map {|date| occurence_calculator.shift_on(date) } } }
      end

      def breaks_in_eight_day_blocks
        eight_day_blocks_with_consecutive_days.map {|eight_day_block| eight_day_block.map {|consecutive_days| consecutive_days.compact.empty? }}
      end

    end
  end
end
