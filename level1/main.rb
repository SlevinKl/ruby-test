# frozen_string_literal: true

require 'json'
require 'date'

def calculate_shift_price(worker, shift)
  shift_date = Date.parse(shift['start_date'])

  case worker['status']
  when 'medic' then shift_date.saturday? || shift_date.sunday? ? 270 * 2 : 270
  when 'interne' then shift_date.saturday? || shift_date.sunday? ? 126 * 2 : 126
  else worker['price_per_shift']
  end
end

def process_data(input_file, output_file)
  data = JSON.parse(File.read(input_file))

  data['workers'].each do |worker|
    number_of_shifts = data['shifts'].count { |shift| shift['user_id'] == worker['id'] }
    pay = 0
    data['shifts'].each do |shift|
      next unless shift['user_id'] == worker['id']

      shift_price = calculate_shift_price(worker, shift)
      pay += shift_price
    end
    worker.merge!('number_of_shifts' => number_of_shifts, 'pay' => pay)
  end

  output_data = { "workers": data['workers'] }

  File.open(output_file, 'w') do |file|
    file.write(JSON.pretty_generate(output_data))
  end
end

process_data('./level3/data.json', './level3/output.json')

# run 'ruby level1/main.rb' to generate output.json
