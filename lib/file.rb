require 'roo'

class File

  def self.parse_file spreadsheet # [{:name=>'',...},..]
    arr = []
    header = spreadsheet.row(1)
    #header.map! {|h| h.to_sym}
    (2..spreadsheet.last_row).each do |i|
      row =  Hash[[header, spreadsheet.row(i)].transpose]
      arr.push row.to_hash
    end
    return arr
  end

  def self.fetch_data_from_spreadsheet str,type
    path = "public/data/#{type}.xlsx"
    sheet = Roo::Excelx.new(path)
    data = File.parse_file sheet
    arr = data.map {|el| el['name']}
    len = str.length
    arr.select {|el| el.downcase[0..len-1] == str.downcase if !el.nil?}[0..9]
  end

  def self.init_data
  	path = 'public/data/data.xlsx'
    sheet = Roo::Excelx.new(path)
    parse_file sheet
  end
  
end