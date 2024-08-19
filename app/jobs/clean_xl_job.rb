class CleanXlJob < ApplicationJob
  queue_as :default
  require 'rubyXL/convenience_methods'
  require 'rubyXL'

  def perform(*args)
    file_path = Rails.root.join('app', 'assets', 'xlsx', 'clients.xlsx')
    workbook = RubyXL::Parser.parse(file_path)
    worksheet = workbook[0]

    # Get the total number of rows
    total_rows = worksheet.sheet_data.size

    # Loop through the rows in reverse order (except the first one) and delete them
    (total_rows - 1).downto(1) do |index|
      worksheet.delete_row(index)
    end

    # Save the workbook after deleting the rows
    workbook.write(file_path)
  end
end
