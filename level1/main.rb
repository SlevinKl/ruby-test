require 'json'

data = JSON.parse(File.read('./level2/data.json'))

data['workers'].each do |worker|
  number_of_shifts = data['shifts'].count { |shift| shift['user_id'] == worker['id'] }
  price_per_shift = case worker['status']
                    when 'medic' then 270
                    when 'interne' then 126
                    else worker['price_per_shift']
                    end
  worker.merge!('number_of_shifts' => number_of_shifts, 'pay' => price_per_shift * number_of_shifts)
end

output_data = { "workers": data['workers'] }

File.open('./level2/output.json', 'w') do |file|
  file.write(JSON.pretty_generate(output_data))
end

# run 'ruby level1/main.rb' to generate output.json
