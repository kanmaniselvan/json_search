require './lib/json_index'

RSpec.describe JsonIndex do
  context 'methods' do
    before(:all) do
      @json_index = JsonIndex.new
    end

    context 'helpers' do
      it 'returns json file name' do
        file_path = '/path/to/json/folder/hello.json'
        expect(@json_index.json_file_name(file_path)).to eq('hello')
      end

      it 'returns string values from nested hash and array' do
        inputs = { a: [1, 3, [3, 4, 6]],
                   b: { c:
                            {d: 'e'}}}

        expect(@json_index.parse_nested_values(inputs)).to eq(%w(1 3 4 6 e))
      end
    end

    context 'initialization' do
      it 'initializes and returns list of files, paths and names' do
        file_paths = %w(./json_files/projects.json ./json_files/users.json)
        files = file_paths.map{|file_path| File.read(file_path)}

        expect(@json_index.files.map{|file_hash| file_hash[:path]}).to eq(file_paths)
        expect(@json_index.files.map{|file_hash| file_hash[:name]}).to eq(%w(projects users))
        expect(@json_index.files.map{|file_hash| file_hash[:file]}).to eq(files)
      end
    end

    context 'getting data from file' do
      before(:all) do
        @complex_json = {
            a: [1, 2],
            b: {
                c: [3, [4, 5]],
                d: {name: 'min'},
                address: 'hello'
            },
            c: [ { food: 'max' } ]
        }

        @json_search = JsonSearch.new(search_values: '||1||2||3||4||5||min||hello||max||',
                                      json_data: @complex_json,
                                      json_data_type: 'sample')
      end

      it 'forms JsonSearch object from the given nested data' do
        expect(@json_index.get_json_search_object(@complex_json, 'sample').to_json).to eq(@json_search.to_json)
      end

      it 'when single json: collects JsonSearch object' do
        file_data = {
            file: @complex_json.to_json,
            name: 'sample',
            path: '/some/where/'
        }

        expect(@json_index.get_index_data(file_data).to_json).to eq([@json_search].to_json)
      end

      it 'when multiple json: collects all JsonSearch objects' do
        file_data = {
            file: [@complex_json, {a: 2}].to_json,
            name: 'sample',
            path: '/some/where/'
        }

        json_result = []
        @json_search.json_data = @complex_json
        json_result << @json_search.dup

        @json_search.json_data = {a: 2}
        @json_search.search_values = '||2||'
        json_result << @json_search.dup

        expect(@json_index.get_index_data(file_data).to_json).to eq(json_result.to_json)
      end

      it 'does not collect JsonSearch object if the JSON file has invalid JSON' do
        file_data = {
            file: @complex_json,
            name: 'sample',
            path: '/some/where/'
        }

        expect{@json_index.get_index_data(file_data)}.to raise_error(StandardError, 'Invalid JSON content in the file - /some/where/')
      end
    end

    context 'indexing' do
      it 'perform indexing and imports all the JSON do to database' do
        JsonSearch.delete_all

        @json_index.index_files

        expect(JsonSearch.first.search_values).to eq('||101||http://example.com/projects-1||9270ed79-35eb-4a38-a46f-35725197ea8d||My first project||Exterior||Workplace Fun||2016-05-21T11:10:28 -10:00||')
      end

      it 'prints indexing status texts' do
        expect{@json_index.index_files}.to output("Indexing ...\nDone.\n").to_stdout
      end

      it 'does not create duplicates search_values if indexed multiple times' do
        @json_index.index_files
        @json_index.index_files

        result_count = JsonSearch.where(search_values: '||101||http://example.com/projects-1||9270ed79-35eb-4a38-a46f-35725197ea8d||My first project||Exterior||Workplace Fun||2016-05-21T11:10:28 -10:00||').count
        expect(result_count).to eq(1)
      end
    end
  end
end
