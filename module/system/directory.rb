require "fileutils"

class System
  class Directory

    def self.create path
      FileUtils.mkdir_p path
    end
  end
end
