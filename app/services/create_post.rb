# frozen_string_literal: true

class CreatePost
  def call(payload)
    puts "add post"
    puts YAML.dump(payload)
    payload
  end

  private

  def save(payload)
    Post.new(
      author: payload["user"],
      category: payload["post_category"],
      title: payload["title"],
      text: payload["text"],
    )
  end
end
