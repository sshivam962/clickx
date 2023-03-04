class Network::SettingsController < Network::BaseController
  before_action :get_user
  before_action :set_bank_account, only: %i[index payout]

  def index
    @account_balance = Stripe::Balance.retrieve(
      stripe_account: current_user.stripe_user_id
    )
  end

  def connect_with_stripe; end

  def stripe_connect
    if params[:account_number] != params[:confirm_account_number]
      @errors = "Account Number re-entered doesn't match"
    else
      @stripe_account = Stripe::Account.create(
        type: 'custom',
        country: params[:country],
        email: @user.email,
        capabilities: {
          card_payments: { requested: true },
          transfers: { requested: true },
        },
        business_type: 'individual',
        individual: {
          first_name: @user.first_name,
          last_name: @user.last_name,
          email: @user.email,
          phone: @user.phone,
          id_number: params[:ssn],
          dob: {
            day: params[:day],
            month: params[:month],
            year: params[:year]
          },
          address: {
            city: params[:city],
            country: params[:country],
            line1: params[:line1],
            line2: params[:line2],
            postal_code: params[:postal_code],
            state: params[:state]
          },
        },
        business_profile: {
          mcc: params[:industry]
        },
        tos_acceptance: {
          date: Time.now.to_i,
          ip: request.remote_ip,
          service_agreement: 'full',
          user_agent: request.user_agent
        },
        external_account: {
          object: 'bank_account',
          country: 'US',
          currency: 'USD',
          account_holder_name: params[:account_holder_name],
          account_holder_type: 'individual',
          routing_number: params[:routing_number],
          account_number: params[:account_number]
        }
      )
      @user.update(stripe_user_id: @stripe_account.id)
    end
  rescue => e
    @errors = e.message
  end

  def edit_stripe_account
    @stripe_account = Stripe::Account.retrieve(current_user.stripe_user_id)
  end

  def update_stripe_account
    if params[:account_number].blank? && params[:ssn].blank?
      stripe_account_params = {
        individual: {
          dob: {
            day: params[:day],
            month: params[:month],
            year: params[:year]
          },
          address: {
            city: params[:city],
            country: params[:country],
            line1: params[:line1],
            line2: params[:line2],
            postal_code: params[:postal_code],
            state: params[:state]
          }
        },
        business_profile: {
          mcc: params[:industry]
        }
      }
    elsif params[:ssn].blank?
      if params[:account_number] != params[:confirm_account_number]
        @errors = 'Please Confirm Your Bank Account Number'
      else
        stripe_account_params = {
          individual: {
            dob: {
              day: params[:day],
              month: params[:month],
              year: params[:year]
            },
            address: {
              city: params[:city],
              country: params[:country],
              line1: params[:line1],
              line2: params[:line2],
              postal_code: params[:postal_code],
              state: params[:state]
            }
          },
          business_profile: {
            mcc: params[:industry]
          },
          external_account: {
            object: 'bank_account',
            country: 'US',
            currency: 'USD',
            account_holder_name: params[:account_holder_name],
            account_holder_type: 'individual',
            routing_number: params[:routing_number],
            account_number: params[:account_number]
          }
        }
      end
    elsif params[:account_number].blank?
      stripe_account_params = {
        individual: {
          dob: {
            day: params[:day],
            month: params[:month],
            year: params[:year]
          },
          id_number: params[:ssn],
          address: {
            city: params[:city],
            country: params[:country],
            line1: params[:line1],
            line2: params[:line2],
            postal_code: params[:postal_code],
            state: params[:state]
          }
        },
        business_profile: {
          mcc: params[:industry]
        }
      }
    else
      if params[:account_number] != params[:confirm_account_number]
        @errors = 'Please Confirm Your Bank Account Number'
      else
        stripe_account_params = {
          individual: {
            dob: {
              day: params[:day],
              month: params[:month],
              year: params[:year]
            },
            id_number: params[:ssn],
            address: {
              city: params[:city],
              country: params[:country],
              line1: params[:line1],
              line2: params[:line2],
              postal_code: params[:postal_code],
              state: params[:state]
            }
          },
          business_profile: {
            mcc: params[:industry]
          },
          external_account: {
            object: 'bank_account',
            country: 'US',
            currency: 'USD',
            account_holder_name: params[:account_holder_name],
            account_holder_type: 'individual',
            routing_number: params[:routing_number],
            account_number: params[:account_number]
          }
        }
      end
    end
    if @errors.blank?
      @stripe_account = Stripe::Account.update(
        current_user.stripe_user_id,
        stripe_account_params,
      )
    end
  rescue => e
    @errors = e.message
  end

  def payout
    @payout = Stripe::Payout.create({
      amount: (params[:payout_amount].to_f * 100).to_i,
      currency: 'usd',
      destination: @bank_account,
    }, {
      stripe_account: current_user.stripe_user_id,
    })
  end

  private

  def get_user
    @user = current_user
  end

  def set_bank_account
    @bank_account = Stripe::Account.retrieve(current_user.stripe_user_id).external_accounts.data.first.id if current_user.stripe_user_id.present?
  end
end
