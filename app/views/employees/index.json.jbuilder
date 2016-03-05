json.array!(@employees) do |employee|
  json.extract! employee, :id, :first_name, :last_name, :phone, :employee_class, :seniority
  json.url employee_url(employee, format: :json)
end
