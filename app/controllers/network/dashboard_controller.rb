class Network::DashboardController < Network::BaseController
  def home
    @projects = Project.where(id: 0)
  end

  def home1
    @projects = Project.includes(:agency)
                        .references(:agencies)
                        .where(search_query)
                        .where(filter_query)
                        .order(order_query)
                        .where(accepted_proposal_id: nil)
                        .paginate(
                          page: params[:page].presence || 1,
                          per_page: 5
                        )

    render 'home'
  end

  def change_start_tour
    set_profile
    @profile.start_tour = 1
    @profile.save
    render json: { status: 200, message: '', data: { content: "" }}
  rescue Exception => e
    @error = e.message
  end

  def set_profile
    @profile = NetworkProfile.find(current_user.network_profile.id)
  end
   
  private

  def order_query
    if params[:type].nil? || params[:type] == 'date'
      'agencies.created_at desc'
    elsif params[:type] == 'price'
      'budget desc'
    end
  end

  def search_query
    return '' if params[:q].blank?

    "projects.title ILIKE '%#{params[:q]}%' OR projects.primary_skill ILIKE '%#{params[:q]}%' OR projects.specific_primary_skill ILIKE '%#{params[:q]}%' OR projects.other_skill ILIKE '%#{params[:q]}%' OR projects.specific_other_skill ILIKE '%#{params[:q]}%' OR projects.other_skill_2 ILIKE '%#{params[:q]}%' OR projects.specific_other_skill_2 ILIKE '%#{params[:q]}%'"
  end

  def filter_query
    return '' if params[:date_posted].blank? && params[:job_type].blank? && params[:budget_estimate].blank? && params[:company].blank?

    query = []
    if params[:date_posted].present?
      case params[:date_posted]
      when "today"
        query.push("Date(projects.created_at) = '#{Date.current}'")
      when "yesterday"
        query.push("Date(projects.created_at) = '#{Date.yesterday}'")
      when "this_week"
        query.push("projects.created_at >= '#{Date.today.at_beginning_of_week}' AND projects.created_at <= '#{Date.today}'")
      when "this_month"
        query.push("projects.created_at >= '#{Date.today.at_beginning_of_month}' AND projects.created_at <= '#{Date.today}'")
      when "last_30_days"
        query.push("projects.created_at >= '#{(Date.today - 30.days)}' AND projects.created_at <= '#{Date.today}'")
      when "this_year"
        query.push("projects.created_at >= '#{Date.today.at_beginning_of_year}' AND projects.created_at <= '#{Date.today}'")
      when "all_time"
        ""
      end
    end
    if params[:budget_estimate].present?
      case params[:budget_estimate]
      when "s_10"
        query.push("budget <= 10000")
      when "s_10_50"
        query.push("budget > 10000 AND budget <= 50000")
      when "s_50_100"
        query.push("budget > 50000 AND budget <= 100000")
      when "s_100"
        query.push("budget > 100000")
      end
    end
    if params[:company].present?
      query.push("agency_id = '#{params[:company]}'")
    end
    query.join(" AND ")
  end
end
