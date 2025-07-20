# lib/tasks/import.rake

require 'roo'

namespace :areas_import do
  desc "Import State and Commune data from Excel"
  task address: :environment do
    puts "Is initializing the country..."
    vn = Erp::Areas::Country.find_or_initialize_by(
      id: 1,
      code: 'vn',
      name: 'Việt Nam'
    )
    vn.save!
    puts "Done initializing the country."

    # === Import States ===
    puts "Importing States..."
    state_file_path = Rails.root.join("engines", "areas", "lib", "assets", "states___14_07_2025.xlsx").to_s
    xlsx = Roo::Spreadsheet.open(state_file_path)
    sheet = xlsx.sheet(0)

    # Giả sử dòng đầu tiên là header
    sheet.each(code: 'Mã', name: 'Tên', note: 'Cấp') do |row|
      next if row[:code] == 'Mã' # Bỏ qua header

      state = Erp::Areas::State.find_or_initialize_by(
        code: row[:code]
      )
      state.name = row[:name]
      state.note = row[:note]
      state.country_id = vn.id
      state.save!
    end
    puts "Done importing States."

    # === Import Districts ===
    puts "Importing Communes..."
    commune_file_path = Rails.root.join("engines", "areas", "lib", "assets", "communes___14_07_2025.xlsx").to_s
    xlsx = Roo::Spreadsheet.open(commune_file_path)
    sheet = xlsx.sheet(0)

    sheet.each(code: 'Mã', name: 'Tên', note: 'Cấp', state_code: 'Mã TP') do |row|
      next if row[:code] == 'Mã' # Bỏ qua header

      state = Erp::Areas::State.find_by(code: row[:state_code])
      if state.nil?
        puts "⚠️ Không tìm thấy State với code: #{row[:state_code]}"
        next
      end

      commune = Erp::Areas::District.find_or_initialize_by(code: row[:code])
      commune.name = row[:name]
      commune.state_id = state.id
      commune.note = row[:note]
      commune.state_code = row[:state_code]
      commune.save!
    end
    puts "Done importing Communes."
  end
end
