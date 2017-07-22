# main execution program to run the scraping process
# Author: Yoonsoo Lee <yoonsoo.lee@nationalgrid.com>
# version: 1.0 (as of Jul. 21, 2017)

require './lib/configure.rb'

class Spider

  @@search_array = []
  @@logger = Logger.new(STDOUT)

  def initialize(search_engine)
    @search_engine = search_engine
  end

  #looking for 'Central'
  def search_ac_type(page)
    if page.css("div.zsg-media-bd").css("div.hdp-fact-ataglance-value").empty?
      return "NA"    # looking for 'Central'
    else
      return page.css("div.zsg-media-bd").css("div.hdp-fact-ataglance-value")[3].text
    end

  end #endof: def search_ac_type()

  def keyword_populate(path)
    raw_data = DataInput.new(path)
    keyword_hash = raw_data.read_data
    return keyword_hash
  end #endof: def keyword_populate

  def scrape_keyword(path)

    result_hash = Hash.new{ |v,k| v[k] = Hash.new()}
    @@count = 0
    @@no_search = 0

    #setup agent
    agent = Mechanize.new{ |agent|
      agent.user_agent_alias = 'Mac Safari'
    }
    agent.ignore_bad_chunking = true
    #keyword
    keyword_hash = keyword_populate(path)

    #setup page
    @search_engine = 'https://www.zillow.com/homes/'  #just use this for now
    keyword_hash.each do |k,v|
      new_key = @search_engine + keyword_hash["#{k}"][:address]
#      puts new_key
      page = agent.get(new_key)
      form = page.forms.first
      page = agent.submit(form)
      ac_type = search_ac_type(page)
      puts k, ac_type                    #test
      if ac_type.include?("Central")
        @@count += 1
      else
        @@no_search += 1
      end
      result_hash["#{k}"][:customer_id] = keyword_hash["#{k}"][:customer_id]
      result_hash["#{k}"][:ac_type] = ac_type
    end #endof: keyword_hash.each do

    result_hash["total_central_ac"] = @@count
    result_hash["total_no_search"] = @@no_search

    result_hash.delete("0")

    save_to_json(result_hash,'./results/central_ac_clifton-park.json2')

    @@logger.info("AC type for #{path.split("raw_data/")[1]} have been scraped.")

    return result_hash.to_json

  end #endof: def scrape_keyword()

  def count_central_ac
    return @@count
  end

  def count_no_search
    return @@no_search
  end

  def save_to_json(data_hash,path)

    File.open(path,"w") do |f|
      f.write(JSON.pretty_generate(data_hash))
    end
  end

  def save_to_csv(data_hash,path)

    CSV.open(path, "wb") do |csv|
      data_hash.each do |k,v|
        csv << hash["#{k}"]
      end
    end
  end #endof: def save_to_csv

end #endof: class Spider


# Run Program

new_spider = Spider.new('zillow')
data_path = './raw_data/cp_address_01.csv'
data_path1 = './raw_data/cp_address_02.csv'
data_path2 = './raw_data/cp_address_03.csv'
data_path3 = './raw_data/cp_address_04.csv'
data_path4 = './raw_data/cp_address_05.csv'
result_path = './results/central_ac_clifton-park01.json'
result_path1 = './results/central_ac_clifton-park02.json'
result_path2 = './results/central_ac_clifton-park03.json'
result_path3 = './results/central_ac_clifton-park04.json'
result_path4 = './results/central_ac_clifton-park05.json'
result_path1 = './results/central_ac_clifton-park.csv'

#hash_output =  new_spider.scrape_keyword(data_path)
#new_spider.save_to_json(hash_output,result_path)
#sleep 1
hash_output1 =  new_spider.scrape_keyword(data_path1)
new_spider.save_to_json(hash_output1,result_path1)
sleep 1
hash_output2 =  new_spider.scrape_keyword(data_path2)
new_spider.save_to_json(hash_output2,result_path2)
sleep 1
hash_output3 =  new_spider.scrape_keyword(data_path3)
new_spider.save_to_json(hash_output3,result_path3)
sleep 1
hash_output4 =  new_spider.scrape_keyword(data_path4)
new_spider.save_to_json(hash_output4,result_path4)


#new_spider.save_to_csv(hash_output,result_path1)



