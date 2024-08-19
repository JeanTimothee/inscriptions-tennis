require 'rubyXL/convenience_methods'
require 'rubyXL'

namespace :registration do
  desc "Destroy all rows in the clients.xlsx file."

  task destroy_all_xl: :environment do
    file_path = Rails.root.join('app', 'assets', 'xlsx', 'clients.xlsx')
    workbook = RubyXL::Parser.parse(file_path)
    worksheet = workbook[0]
    total_rows = worksheet.sheet_data.size
    # Loop through the rows in reverse order (except the first one) and delete them
    (total_rows - 1).downto(1) do |index|
      worksheet.delete_row(index)
    end

    workbook.write(file_path)
  end

end
