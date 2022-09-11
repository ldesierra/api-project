module Helpers
  module LogCustomerIn
    def log_customer_in(customer)
      post '/customers/sign_in', params: {
        customer: {
          email: customer.email,
          password: customer.password
        }
      }

      response.headers['Authorization']
    end
  end
end
