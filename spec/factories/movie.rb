FactoryGirl.define do
  factory :movie do
    title 'A fake title'
    id 1
    release_date {10.years.ago}
  end
end