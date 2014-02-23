class Aspect

  @@data = {}

  class << self

    def data
      @@data
    end

    def add(file, name, key, val=nil)
      @@data[file] ||= {}
      @@data[file][name] ||= {}
      @@data[file][name][key] = val || true
    end

    # Aspect.load_from_dir 'app/controllers'
    def load_from_dir(dir)
      for file in Dir["#{Rails.root}/#{dir.gsub(/^\/|\/$/,'')}/*.rb"]
        Aspect.load_from_file file
      end
    end

    # Aspect.load_from_file "#{Rails.root}/app/api/favorite_api.rb"
    def load_from_file(file)
      file_name = file.split('/').last.sub(/\.rb$/,'')

      return @@data[file_name] if @@data[file_name]

      sub_name = nil 

      data = File.read file
      for line in data.split("\n").reverse
        test_sub    = line.split(/def\s+/)
        if test_sub[1]
          data = test_sub[1].chomp.split(/[^\w_!]/)
          sub_name = data[0]
        end
        test_aspect = line.split(/#=\s+/)
        if test_aspect[1]
          data = test_aspect[1].chomp.split(/[\s:]+/, 2)
          data[1] = true if data[1] == ''
          Aspect.add file_name, sub_name, data[0], data[1]
        end
      end

      @@data[file_name] || {}
    end

  end

end

class Object
  def self.aspects
    Aspect.load_from_file caller[0].split(':')[0]
  end
end
