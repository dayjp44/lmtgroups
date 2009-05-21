module SiteHelper

  def attendance_status(member_id, report_id)
    rd = ReportDetail.find_by_member_id_and_report_id(member_id, report_id)
    if rd.nil?
      return false
    else
      if rd.status.nil? || rd.status.blank?
        return false
      else
        return rd.status
      end
    end
  end
end
