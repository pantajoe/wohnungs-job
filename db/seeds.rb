require 'faker'

def rand_in_range(from, to)
  # pick random datetime inbetween range
  Time.at(rand * (to.to_f - from.to_f) + from.to_f)
end

def create_incidents(project)
  # Create closed incidents
  3.times do |_index|
    project.incidents.create(time_from: rand_in_range(48.hours.ago, 47.hours.ago), time_to: rand_in_range(47.hours.ago, 46.hours.ago), which_server: Faker::Code.nric,
                             what_happened: "#{Faker::Hacker.abbreviation} #{Faker::Hacker.verb} #{Faker::Hacker.noun}", realized_error: "#{Faker::Hacker.abbreviation} #{Faker::Hacker.ingverb}",
                             impacts: "#{Faker::Hacker.abbreviation} #{Faker::Hacker.verb} #{Faker::Hacker.noun}", solution: "#{Faker::Hacker.verb} #{Faker::Hacker.adjective} #{Faker::Hacker.noun}", future_approach: Faker::Hacker.say_something_smart)
  end

  # Create closed incidents for last month
  3.times do |_index|
    project.incidents.create(time_from: rand_in_range(748.hours.ago, 747.hours.ago), time_to: rand_in_range(747.hours.ago, 746.hours.ago), which_server: Faker::Code.nric,
                             what_happened: "#{Faker::Hacker.abbreviation} #{Faker::Hacker.verb} #{Faker::Hacker.noun}", realized_error: "#{Faker::Hacker.abbreviation} #{Faker::Hacker.ingverb}",
                             impacts: "#{Faker::Hacker.abbreviation} #{Faker::Hacker.verb} #{Faker::Hacker.noun}", solution: "#{Faker::Hacker.verb} #{Faker::Hacker.adjective} #{Faker::Hacker.noun}", future_approach: Faker::Hacker.say_something_smart)
  end
end

def create_performance_data(project)
  (2.months.ago.to_date..Date.today).to_a.each do |date|
    performance = project.performances.create(date: date, requests: (1000..2000).to_a.sample, response_time: (20..70).to_a.sample, error_rate: (1..10).collect {|v| v.to_f }.sample, clean_errors: (10..200).to_a.sample)
    performance.save
  end
end

if Project.where(repo_name: "hosting-reporter").blank?
  host_rep = Project.create(title: "Hosting Reporter", repo_name: "hosting-reporter", appsignal_id: "59e9086bb504f52d0ac86a0e", customer: "Herr Felix Seidel", email: "kunde@example.com")
  host_rep.save(validate: false)
  create_incidents(host_rep)
  # remove when API for data is set up
  create_performance_data(host_rep)
  puts "Created project #{host_rep.title} with incidents and performance data"
end

# Create projects
(1...5).to_a.map {|t| "project_#{t}" }.each do |name|
  company = Faker::Company.name
  name = Project.create(title: company, repo_name: company.downcase.gsub(', ', '-').tr(' ', '-'), appsignal_id: Faker::Vehicle.vin, customer: "#{%w[Herr Frau].sample} #{Faker::HowIMetYourMother.character}", email: Faker::Internet.email)
  name.save(validate: false)

  create_incidents(name)
  create_performance_data(name)
  puts "Created project #{name.title} with incidents and performance data"
end

# Create archived projects
(6...9).to_a.map {|t| "project_#{t}" }.each do |name|
  company = Faker::Company.name
  name = Project.create(title: company, repo_name: company.downcase.gsub(', ', '-').tr(' ', '-'), appsignal_id: Faker::Vehicle.vin, customer: "#{%w[Herr Frau].sample} #{Faker::HarryPotter.character}", email: Faker::Internet.email, archived: true)
  name.save(validate: false)

  create_incidents(name)
  create_performance_data(name)
  puts "Created project #{name.title} with incidents and performance data"
end
