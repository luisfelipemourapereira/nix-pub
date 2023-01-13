namespace :test do
  %w[rio blackmatter].each do |t|
    desc %(run #{t} test)
    task t do
      Build.send(t)
    end
  end
end
