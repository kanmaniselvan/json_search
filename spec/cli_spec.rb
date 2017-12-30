RSpec.describe 'CLI JSONSearch' do
  context 'index' do
    it 'perform indexing and imports all the JSON do to database' do
      JsonSearch.delete_all

      system('bin/index_json_files')
      expect(JsonSearch.first.search_values).to eq('||101||http://example.com/projects-1||9270ed79-35eb-4a38-a46f-35725197ea8d||My first project||Exterior||Workplace Fun||2016-05-21T11:10:28 -10:00||')
    end

    it 'prints indexing status texts' do
      expect{ system('bin/index_json_files') }.to output("Indexing ...\nDone.\n").to_stdout_from_any_process
    end

    it 'does not create duplicates search_values if indexed multiple times' do
      system('bin/index_json_files')
      system('bin/index_json_files')

      result_count = JsonSearch.where(search_values: '||101||http://example.com/projects-1||9270ed79-35eb-4a38-a46f-35725197ea8d||My first project||Exterior||Workplace Fun||2016-05-21T11:10:28 -10:00||').count
      expect(result_count).to eq(1)
    end
  end

  context 'searches' do
    it 'returns the search results in human readable format ignoring case' do
      result_string = "\n-------------------------------------------- USERS (2) ---------------------------------------------\n\n\n************* 1 **************\n\nid                            : 2 \nExternal id                   : c9995ea4-ff72-46e0-ab77-dfe0ae1ef6c2 \nName                          : Joni Mitchell \nAlias                         : Miss Joni \nCreated at                    : 2016-06-23T10:31:39 -10:00 \nActive                        : true \nVerified                      : true \nShared                        : false \nLocale                        : zh-CN \nTimezone                      : Armenia \nLast login at                 : 2012-04-12T04:03:28 -10:00 \nEmail                         : test2@example.com \nPhone                         : 9575-552-585 \nSignature                     : Don't Worry Be Happy! \nOrganization id               : 106 \nTags                          : Foxworth Woodlands Herlong Henrietta \nSuspended                     : false \nRole                          : member \nLocation                      : City => Melbourne \n\n************* 2 **************\n\nid                            : 3 \nExternal id                   : c9995ea4-ff72-46e0-ab77-dfe0ae1ef6c2 \nName                          : Joni Mitchell2 \nAlias                         : Miss Joni \nCreated at                    : 2016-06-23T10:31:39 -10:00 \nActive                        : true \nVerified                      : true \nShared                        : false \nLocale                        : zh-CN \nTimezone                      : Armenia \nLast login at                 : 2012-04-12T04:03:28 -10:00 \nEmail                         : test3@example.com \nPhone                         : 9575-552-585 \nSignature                     : Don't Worry Be Happy! \nOrganization id               : 106 \nTags                          : Foxworth Woodlands Herlong Henrietta \nSuspended                     : false \nRole                          : member \nLocation                      : City => Melbourne \n\n----------------------------------------------------------------------------------------------------\n\n"
      expect{ system('bin/search_json "miSS jOnI"') }.to output(result_string).to_stdout_from_any_process
    end

    it "returns 'No results.' if nothing found" do
      expect{ system('bin/search_json "missing joni"') }.to output("No results.\n").to_stdout_from_any_process
    end

    it "returns 'No results.' if blank string is given" do
      expect{ system('bin/search_json ') }.to output("No results.\n").to_stdout_from_any_process
    end
  end
end
