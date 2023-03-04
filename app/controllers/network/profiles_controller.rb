class Network::ProfilesController < Network::BaseController
  def show
    @profile = current_user.network_profile
    fetch_my_casestudy_industries
  end

  def edit
    @profile = current_user.network_profile
    (6 - @profile.skills.count).times { @profile.skills.build }
    @profile.work_profiles.build if @profile.work_profiles.blank?
  end

  def update
    current_user.update(first_name: params[:first_name]) if params[:first_name].present?
    current_user.update(last_name: params[:last_name]) if params[:last_name].present?
    if current_user.network_profile.blank?
      current_user.create_network_profile(profile_params)
    else
      stats_params = params[:network_profile][:stats]
      @stats = {}

      unless stats_params['1'].to_unsafe_h.values.any?(&:blank?)
        @stats['1'] = stats_params['1']
      end
      unless stats_params['2'].to_unsafe_h.values.any?(&:blank?)
        @stats['2'] = stats_params['2']
      end
      unless stats_params['3'].to_unsafe_h.values.any?(&:blank?)
        @stats['3'] = stats_params['3']
      end
      unless stats_params['4'].to_unsafe_h.values.any?(&:blank?)
        @stats['4'] = stats_params['4']
      end

      current_user.network_profile.stats = @stats
      current_user.network_profile.update(profile_params)
    end

    redirect_to network_profile_path
  end

  def update_logo
    current_user.logo = Cloudinary::Uploader.upload(params[:user][:logo], options = {})['secure_url']
    current_user.save
  end

  def update_background_image
    @profile = current_user.network_profile
    @profile.background_image = Cloudinary::Uploader.upload(params[:profile][:background_image], options = {})['secure_url']
    @profile.save
  end

  def upload_pdf
    @profile = current_user.network_profile
    @profile.cv = Cloudinary::Uploader.upload(params[:user][:cv], options = {})['secure_url']
    @profile.save
  end

  def download_cv
    @profile = current_user.network_profile
    send_data(
      open(@profile.cv).read,
      filename: "resume.pdf",
      type: 'application/pdf',
      disposition: 'attachment'
    )
  end

  private

  def profile_params
    params.require(:network_profile).permit(
      :description, :cv, :available_hours, :time_period, :linkedin, :facebook, :instagram, :dribbble, :overview,
      skills_attributes: [:id, :name, :value, :_destroy],
      network_portfolios_attributes: [:id, :heading, :paragraph, :_destroy],
      work_profiles_attributes: [:id, :title, :description, :_destroy]
    )
  end

  def fetch_my_casestudy_industries
    @my_case_study_industries =
      Industry.includes(:case_studies, :funnel_page)
              .where.not(case_studies: {id: nil})
              .where(case_studies: {network_profile_id: current_user.network_profile.id})
              .order(updated_at: :asc)
  end
end
