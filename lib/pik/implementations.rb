
module Pik
  
  module Packages

    extend self

    def [](key)
      packages[key]
    end

    def packages
      @packages ||= YAML.load(read('http://vert.igino.us/pik/packages.yml'))
    end

    def read(package)
      uri = URI.parse(package)
      uri.read rescue ''
    end

  end

  module Implementations

    extend self

    def rubies 
      @rubies ||= Packages['rubies']
    end

    def list
      h = Hash.new{|h,k| h[k] = [] }
      rubies.each{|name,data| h[data[:implementation]] << name  }
      h
    end
    
    def [](key)
      all_rubies[key]
    end

    def all_rubies
      return @all_rubies if @all_rubies
      @all_rubies = {}
      rubies.each do |name, data| 
        data = data.merge(:name => full(name)) 
        @all_rubies[full(name)]  = data
        @all_rubies[short(name)] = data
      end
      @all_rubies  
    end

    def full(name)
      name.gsub(/[\[\]]/,'')
    end

    def short(name)
      name.gsub(/\[.+?\]/,'')
    end
    
#     class Base
    
#       def self.find(*args)
#         new.find(*args)
#       end
      
#       def initialize
#         @url = 'http://rubyforge.org'
#       end

#       def url
#         @url + @path
#       end
      
#       def find(*args)
#         if args.empty?
#           return most_recent
#         else
#           pattern = Regexp.new(Regexp.escape(args.first))
#           versions.select{|v,k| v =~ pattern }.max
#         end
#       end
          
#       def most_recent(vers=versions)
#         vers.max
#       end
      
#       def versions
#         h = {}
#         Hpricot(read).search("a") do |a|
#           if a_href = a.attributes['href']
#             href, link, version, rc = *a_href.match(@re)
#             h["#{version}#{rc}"] =  @url + link  if version
#           end
#         end
#         h
#       end
  
#       def read
#         uri = URI.parse(@url+@path)
#         uri.read rescue ''
#       end    
  
#       def subclass
#         self.class.to_s.split('::').last
#       end
      
#       def name
#         subclass.downcase
#       end
      
#       def after_install(install)
#         puts
#         p = Pik::Add.new([install.target + 'bin'], install.config)
#         p.execute
#         p.close
#       end
  
#     end

  end
  
end