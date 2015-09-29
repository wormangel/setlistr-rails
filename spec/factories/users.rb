FactoryGirl.define do
  factory :user do
    name "Curt Kobain"
    
    factory :user_with_contracts do
    
      transient do
        bands []
      end
      
      after(:create) do |user, evaluator|
        evaluator.bands.each do |b|
          create(:contract, user: user, band: b)
        end
      end
    end
  end
end