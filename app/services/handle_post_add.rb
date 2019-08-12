# frozen_string_literal: true

class HandlePostAdd
  def call(payload)
    puts "add post"
    puts YAML.dump(payload)
  end
end
