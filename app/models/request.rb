class Request
  include Mongoid::Document
  store_in database: ->{ Thread.current[:database] }
  field :age, type: Integer, default: ->{ nil }
  field :gender, type: String, default: ->{ nil }
  field :name, type: String, default: ->{ nil }
  field :countryoforigin, type: String, default: ->{ nil }
  field :groupsize, type: Integer, default: ->{ nil }
  field :countryofseperation, type: String, default: ->{ nil }
  field :status, type: String, default: ->{ nil }
end
