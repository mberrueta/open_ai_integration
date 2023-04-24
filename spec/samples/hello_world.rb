module Samples
  class HelloWorld
    def say_hello
      "Hello World! #{name}"
    end

    def name
      @name ||= "John Doe"
    end
  end
end
