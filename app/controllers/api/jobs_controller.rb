# frozen_string_literal: true

module Api
  class JobsController < ApplicationController
    include Pagy::Backend

    skip_before_action :verify_authenticity_token, only: [:authenticate]

    PAGE_LIMT = 25

    def index
      JWT.decode bearer_token, hmac_secret, true, { algorithm: 'HS256' }

      pagy, jobs = pagy(Job.all.order(sponsorship_level: :desc), items: PAGE_LIMT)
      render status: 200, json: { data: jobs.as_json,
                                  pagy: pagy_metadata(pagy) }
    rescue JWT::ExpiredSignature, JWT::DecodeError
      render status: 401, json: {}
    end

    def authenticate
      if params[:password] == job_board_password
        exp_time = (Time.now + 7.days).to_i
        token = JWT.encode({ data: '', exp: exp_time }, hmac_secret, 'HS256')

        render status: 201, json: { token: token }
      else
        render status: 401, json: {}
      end
    end

    private

    def bearer_token
      request.headers['Authorization'].split.last
    end

    def hmac_secret
      ENV.fetch('JWT_HMAC_SECRET', nil)
    end

    def job_board_password
      ENV.fetch('JOB_BOARD_PASSWORD', nil)
    end
  end
end
