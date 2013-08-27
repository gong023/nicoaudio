class System
  class File

    def self.create(name, &prc)
      $stdout = open(name, "w")
      puts yield
      $stdout.flush
    end
  end
end
