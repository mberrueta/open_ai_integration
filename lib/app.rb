class App < Thor
  package_name :app
  map "-L" => :list

  desc "test ARG", "print hello"

  def install(name)
    pp "hello #{name}"
  end

  desc "list [SEARCH]", "list all of the available apps, limited by SEARCH"

  def list(search = "")
  end
end
