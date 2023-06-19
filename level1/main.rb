require 'json'

data = JSON.parse(File.read('./level1/data.json'))

data['workers'].each do |worker|
  number_of_shifts = data['shifts'].count { |shift| shift['user_id'] == worker['id'] }
  worker['number_of_shifts'] = number_of_shifts
  worker['pay'] = number_of_shifts * worker['price_per_shift']
end

output_data = { "workers": data['workers'] }

File.open('./level1/output.json', 'w') do |file|
  file.write(JSON.pretty_generate(output_data))
end

# run 'ruby level1/main.rb' to generate output.json
