FactoryBot.define do
  factory :open_hour do
    day { Faker::Number.between(from: 0, to: 6) }
    start_time { Faker::Time.forward(days: 1, period: :morning) }
    end_time { Faker::Time.forward(days: 1, period: :evening) }
  end
end
