class PipelineFilterGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def generate_filter
    template  "filter.rb.erb", "app/models/call_out/pipeline/#{file_name}.rb"
    template  "filter_spec.rb.erb", "spec/models/call_out/pipeline/#{file_name}_spec.rb"
  end

  private
  
  def file_name
    super.underscore
  end

  def class_name
    file_name.classify
  end

end
