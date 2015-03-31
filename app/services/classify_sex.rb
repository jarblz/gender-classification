class ClassifySex  
	#Set up all of the temporary data structures needed in order to
	#1. Train our classifyer
	#2. Make a prediction
	def initialize
		female_class = Person.where(sex: "Female")
		male_class = Person.where(sex: "Male")
		@height_feature = Hash.new{ |h, k| h[k] = [] }
		@weight_feature = Hash.new{ |h, k| h[k] = [] }

		male_frequency = 0.0
		female_frequency = 0.0
		male_class.each do |record|
			@weight_feature[record.sex] << record.weight
			@height_feature[record.sex] << record.height
			male_frequency += 1
		end
		female_class.each do |record|
			@weight_feature[record.sex] << record.weight
			@height_feature[record.sex] << record.height
			female_frequency += 1
		end
		@prior_male = (male_frequency/(male_frequency+female_frequency))
		@prior_female = (female_frequency/(male_frequency+female_frequency))
		#male height and variance, for each feature
		@male_height_mean = mean *@height_feature["Male"]
		@male_height_variance = variance @male_height_mean, *@height_feature["Male"]
		@male_weight_mean = mean *@weight_feature["Male"]
		@male_weight_variance = variance @male_weight_mean, *@weight_feature["Male"]
		#Female height and variance, for each feature
		@female_height_mean = mean *@height_feature["Female"]
		@female_height_variance = variance @female_height_mean, *@height_feature["Female"]
		@female_weight_mean = mean *@weight_feature["Female"]
		@female_weight_variance = variance @female_weight_mean, *@weight_feature["Female"]		
=begin
		puts "==================="
		puts @male_height_mean
		puts @male_weight_mean
		puts @male_height_variance
		puts @male_weight_variance
		puts "==================="
		puts @female_height_mean
		puts @female_weight_mean
		puts @female_height_variance
		puts @female_weight_variance
		puts "==================="	
=end

	end

	def mean(*args)
		return (args.sum)/(args.length)
	end
	
	def variance(mean,*args)
		#compute variance:
		#e.g. sum ((height - mean_height).exp(2))/total_female_height_measurements)/4
		sum=0.0
		args.each do |arg|
			sum += (arg-mean)**2
		end
		
		return sum/args.length

	end
	def classify(height,weight)
		puts "male: #{get_male_score(height,weight)}"
		puts "female: #{get_female_score(height,weight)}"

		if get_female_score(height, weight) > get_male_score(height, weight)
			return "Female"
		elsif get_female_score(height, weight) < get_male_score(height, weight)
			return "Male"
		else
			return "unknown"
		end
	end

	def get_female_score(height,weight)
		pi = Math::PI
		e = Math::E
		exp_h = (-1/2)*((height-@female_height_mean)**2/@female_height_variance)
		exp_w = (-1/2)*((weight-@female_weight_mean)**2/@female_weight_variance)
		likelihood_h = (1/Math.sqrt(2*pi*@female_height_variance))*(e**exp_h)
		likelihood_w = (1/Math.sqrt(2*pi*@female_weight_variance))*(e**exp_w)
		return (likelihood_w*likelihood_h*@prior_female)
	end
	def get_male_score(height,weight)
		pi = Math::PI
		e = Math::E
		exp_h = (-1/2)*((height-@male_height_mean)**2/@male_height_variance)
		exp_w = (-1/2)*((weight-@male_weight_mean)**2/@male_weight_variance)
		likelihood_h = (1/Math.sqrt(2*pi*@male_height_variance))*(e**exp_h)
		likelihood_w = (1/Math.sqrt(2*pi*@male_weight_variance))*(e**exp_w)
		return (likelihood_w*likelihood_h*@prior_male)
	end
end

