module Common
  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end
end
