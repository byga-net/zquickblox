module ZQuickblox
  module User
    class UpdateUserRequest < Request
      def initialize(id, params)
        super(:json)
        @uri = "/users/#{id}.json"
        @method = :put
        @params = params
      end
    end
  end
end
