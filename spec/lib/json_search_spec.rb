require './lib/json_search'

RSpec.describe JsonSearch do
  context 'helpers' do
    it 'with ljust: returns sanitized key string with underscore removed and capitalized' do
      expect(JsonSearch.get_sanitized_key('key_hi')).to eq('Key hi                        ')
    end

    it 'without ljust: returns sanitized key string with underscore removed and capitalized' do
      expect(JsonSearch.get_sanitized_key('key_hi', false)).to eq('Key hi')
    end

    it 'returns result group separator string' do
      expect(JsonSearch.get_group_separator('end')).to eq('------------------------------------------------end-------------------------------------------------')
    end

    it 'returns result index number string' do
      expect(JsonSearch.get_result_number(1)).to eq('************* 1 **************')
    end

    it 'returns readable string from given nested json/array' do
      nested_json =  {
          a: [1, 2],
          b: {
              c: [3, [4, 5]],
              d: {name: 'min'},
              address: 'hello'
          },
          c: [ 'q', 'v', {
                   food: 'max',
                   result: [
                       super: 'fat'
                   ] } ]
      }

      expect(JsonSearch.get_readable_nested_values(nested_json)).to eq("\n     A => 1 2 \n     B => \n          C => 3 4 5 \n          D => \n               Name => min \n          Address => hello \n     C => q v \n          Food => max \n          Result => \n               Super => fat ")
    end
  end

  context 'result formatting' do
    it 'returns the combined formatted search result' do
      results = []
      results << JsonSearch.find_by(json_data_type: 'users')
      results << JsonSearch.find_by(json_data_type: 'projects')
      result_string = "\n-------------------------------------------- USERS (1) ---------------------------------------------\n\n\n************* 1 **************\n\nid                            : 1 \nExternal id                   : 74341f74-9c79-49d5-9611-87ef9b6eb75f \nName                          : Raylan Givens \nCreated at                    : 2016-04-15T05:19:46 -10:00 \nActive                        : true \nVerified                      : true \nShared                        : false \nLocale                        : en-AU \nTimezone                      : Sri Lanka \nLast login at                 : 2013-08-04T01:03:27 -10:00 \nEmail                         : test@example.com \nPhone                         : 8335-422-718 \nOrganization id               : 119 \nTags                          : Springville Sutton Hartsville/Hartley Diaperville \nSuspended                     : true \nRole                          : admin \n\n----------------------------------------------------------------------------------------------------\n\n------------------------------------------- PROJECTS (1) -------------------------------------------\n\n\n************* 1 **************\n\nid                            : 101 \nUrl                           : http://example.com/projects-1 \nExternal id                   : 9270ed79-35eb-4a38-a46f-35725197ea8d \nName                          : My first project \nTags                          : Exterior Workplace Fun \nCreated at                    : 2016-05-21T11:10:28 -10:00 \n\n----------------------------------------------------------------------------------------------------\n\n"
      expect(JsonSearch.get_human_readable_format(results)).to eq(result_string)
    end

    it 'returns individual JSON data in human readable format' do
      json_search_record = [JsonSearch.find_by(json_data_type: 'users')]
      result_string = "\n\n************* 1 **************\n\nid                            : 1 \nExternal id                   : 74341f74-9c79-49d5-9611-87ef9b6eb75f \nName                          : Raylan Givens \nCreated at                    : 2016-04-15T05:19:46 -10:00 \nActive                        : true \nVerified                      : true \nShared                        : false \nLocale                        : en-AU \nTimezone                      : Sri Lanka \nLast login at                 : 2013-08-04T01:03:27 -10:00 \nEmail                         : test@example.com \nPhone                         : 8335-422-718 \nOrganization id               : 119 \nTags                          : Springville Sutton Hartsville/Hartley Diaperville \nSuspended                     : true \nRole                          : admin \n\n"
      expect(JsonSearch.readable_json_data(json_search_record)).to eq(result_string)
    end
  end

  context 'search' do
    it 'returns separator joined search keyword' do
      expect(JsonSearch.get_separator_joined_keyword('hello')).to eq('||hello||')
    end

    it 'returns the search results in human readable format' do
      result_string = "\n-------------------------------------------- USERS (2) ---------------------------------------------\n\n\n************* 1 **************\n\nid                            : 2 \nExternal id                   : c9995ea4-ff72-46e0-ab77-dfe0ae1ef6c2 \nName                          : Joni Mitchell \nAlias                         : Miss Joni \nCreated at                    : 2016-06-23T10:31:39 -10:00 \nActive                        : true \nVerified                      : true \nShared                        : false \nLocale                        : zh-CN \nTimezone                      : Armenia \nLast login at                 : 2012-04-12T04:03:28 -10:00 \nEmail                         : test2@example.com \nPhone                         : 9575-552-585 \nSignature                     : Don't Worry Be Happy! \nOrganization id               : 106 \nTags                          : Foxworth Woodlands Herlong Henrietta \nSuspended                     : false \nRole                          : member \nLocation                      : City => Melbourne \n\n************* 2 **************\n\nid                            : 3 \nExternal id                   : c9995ea4-ff72-46e0-ab77-dfe0ae1ef6c2 \nName                          : Joni Mitchell2 \nAlias                         : Miss Joni \nCreated at                    : 2016-06-23T10:31:39 -10:00 \nActive                        : true \nVerified                      : true \nShared                        : false \nLocale                        : zh-CN \nTimezone                      : Armenia \nLast login at                 : 2012-04-12T04:03:28 -10:00 \nEmail                         : test3@example.com \nPhone                         : 9575-552-585 \nSignature                     : Don't Worry Be Happy! \nOrganization id               : 106 \nTags                          : Foxworth Woodlands Herlong Henrietta \nSuspended                     : false \nRole                          : member \nLocation                      : City => Melbourne \n\n----------------------------------------------------------------------------------------------------\n\n"
      expect(JsonSearch.search('miss joni')).to eq(result_string)
    end

    it "returns 'No results.' if nothing found" do
      expect(JsonSearch.search('missing joni')).to eq('No results.')
    end
  end
end
