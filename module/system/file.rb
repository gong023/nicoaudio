class System
  class File

    def self.create(name, &prc)
      open(name, "w") { yield }
    end
  end
end
