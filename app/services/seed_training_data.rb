class SeedTrainingData

	def initialize
		rand(500..1000).times do |x|
			female = Person.new
			female.sex = "Female"
			female.height = "#{rand(4..5)}.#{rand(1..11)}".to_f
			female.weight = rand(115..180).to_f
			female.save
		end
		rand(500..1000).times do |x|	
			male = Person.new
	 		male.sex = "Male"
			male.height = "#{rand(5..6)}.#{rand(1..11)}".to_f
			male.weight = rand(150..235).to_f
			male.save
		end
	end

end