# Author: Yoonsoo Lee
# The method takes outside data source and populates the input for spider.rb

require './lib/configure.rb'

class Fixnum
  def num_digits
    Math.log10(self).to_i + 1
  end
end

class DataInput

  def initialize(path)

    @path = path

  end

  # reads raw address data from CSV
  def read_data
    data_matrix = Hash.new{ |v,k| v[k] = Hash.new()}
    data_table = {}
    i = 0
    CSV.foreach("#{@path}") do |row|
      # row[11] is zipcodes. See if it is missing '0' and adds to make it a full 5-digit zip
      if i >= 1
        init_zip = row[11].to_i                     # row[?]: zipcodes will depend on the data provided by users
        full_zip = zip_correct(init_zip)
      end
      data_table[:address] = row[3]+"-"+row[4].to_s+row[5].to_s+" "+row[6]+"-"+row[7].to_s+" "+row[8].to_s+"-"+row[9]+"-"+row[10]+"-"+"#{full_zip}"
      data_table[:customer_id] = row[1]
      data_matrix["#{i}"].merge!(data_table)

      i += 1
    end

    return data_matrix
  end #endof: def read_data

  # corrects zip codes that start with '0'
  def zip_correct(zip)
    if zip.num_digits == 4
      zip = "0"+zip.to_s
    end
    return zip
  end #endof: def zip_correct()

  # creates JSON from the data hash
  def read_data_json(data_hash)
    return data_hash.to_json
  end #endof: def read_data_json

  # just tease out the addresses to be used as crawl keyword
  def address_only(hash)
    address_hash = {}
    address = []

    hash.each do |k,v|
      address = hash["#{k}"][:address]
      address_hash["#{k}"] = address
    end

    return address_hash

  end #endof: def address_only


end #endof: class DataInput


# test
ciap_path = "./raw_data/cp_address.csv"
base = DataInput.new(ciap_path)
base_data = base.read_data

#puts base_data
#puts base.address_only(base_data)

address_hash = {}
addresses = []
base_data.each do |k,v|
#  address_hash[:keyword] = base_data["#{ind}"][:address]
  addresses = base_data["#{k}"][:address]
  address_hash["#{k}"] = addresses
end
#puts address_hash[3]