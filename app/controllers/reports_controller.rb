class ReportsController < ApplicationController
  def index
    [:start_date, :end_date].each do |field|
      params.delete(field) if params[field].blank?
    end
    redirect_to dossier_report_path(report: params[:report_name].downcase.gsub(' ', '_'), options: params)
  end

end
