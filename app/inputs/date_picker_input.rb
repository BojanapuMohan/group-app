class DatePickerInput < SimpleForm::Inputs::StringInput

  def input_html_classes
    super.push('shiftdate')
  end

  def input_html_options
    options = super
    data = options.fetch('data') { {} }
    data['date_format'] = "yyyy-mm-dd"
    options['data'] = data
    options
  end

  private

  def string?
    true
  end
end
