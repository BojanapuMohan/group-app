module CallOut
  class Pipeline

    attr_accessor :employee_list, :call_out_shift, :context

    def initialize(employee_list, call_out_shift, context = {})
      @employee_list = employee_list
      @call_out_shift = call_out_shift
      @context = context
    end

    def call
      filters.each {|filter| filter.call(self, employee_list, call_out_shift, context)}
    end

    def start_date
      call_out_shift.start_date
    end

    def end_date
      call_out_shift.end_date
    end

    def shift_occurrences
      call_out_shift.occurrences
    end

    def shift
      call_out_shift.shift
    end

    def employees_role
      shift.employees_role
    end

    def facility
      shift.facility
    end

    def filters
      [
        CallOut::Pipeline::AlreadyWorkingFilter,
        CallOut::Pipeline::AlreadyWorkingRegularPtFilter,
        CallOut::Pipeline::RegularFtptVacationFilter,
        CallOut::Pipeline::AlreadyWorkingBetterOptionFilter,
        CallOut::Pipeline::OvertimeInLastTwentyFourHoursFilter,
        CallOut::Pipeline::OvertimeOneWeekFilter,
        CallOut::Pipeline::OvertimeConsecutiveDaysFilter,
        CallOut::Pipeline::OvertimeConsecutiveDaysRnAndLpnFilter,
        CallOut::Pipeline::AlreadyWorkingRegularPtOverTimeFilter,
        CallOut::Pipeline::DeclinedStraightTimeFilter,
        CallOut::Pipeline::UsedToBeMyShiftAndICantHaveItAgain
      ]
    end
  end
end
