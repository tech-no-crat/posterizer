module UsersHelper
  def possesses(word)
    if word[word.length - 1] == 's'
      word + "'"
    else
      word + "'s"
    end
  end
end
