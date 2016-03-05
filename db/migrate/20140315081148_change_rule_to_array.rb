class ChangeRuleToArray < ActiveRecord::Migration
  def up
    remove_column :employee_call_outs, :rule
    add_column :employee_call_outs, :rule, :string, array: true, default: '{}'
  end
end
