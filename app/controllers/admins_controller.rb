# frozen_string_literal: true

class AdminsController < ApplicationController
  # skip_callback(*_process_action_callbacks.map(&:filter))
  http_basic_authenticate_with name: ENV['ADMIN_NAME'],
                               password: ENV['ADMIN_PASS']

  def admin
    if request.post?
      @ip_address = IpAddress.create(ip_params)
      redirect_to admin_path
    else
      @ip_addresses = IpAddress.all
      @ip_address = IpAddress.new
    end
  end

  def destroy_ip
    @ip_address = IpAddress.find(params[:id])
    @ip_address.destroy
    redirect_to admin_path
  end

  def users_list
    @path = Rails.root.join('tmp', "clients_#{Date.current.strftime('%Y%m%d')}.csv")

    CSV.open(@path, 'w+b') do |file|
      file << ['User Name', 'Email', 'Domain', 'Company', 'Agency', 'Type',
               'Labels']
      Business.includes(:labels).order(:name).each do |biz|
        type = biz.managed_service? ? 'Service' : 'Non-Service'
        biz.users.normal.each do |user|
          file << [
            user.name, user.email,
            biz.domain, biz.name,
            biz.agency_name, type,
            biz.labels_list.join(', ')
          ]
        end
      end
    end

    send_file @path
  end

  private

  def ip_params
    params.require(:ip_address).permit(:ip)
  end
end
