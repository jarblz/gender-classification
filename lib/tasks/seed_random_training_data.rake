task :seed_random_training_data => :environment do

	SeedTrainingData.new()
end