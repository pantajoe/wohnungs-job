class Object
  def switch(hash)
    hash.each do |method, proc|
      return proc[] if send method
    end

    yield if block_given?
  end
end
