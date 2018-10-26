[NilClass, String, Integer, Float, Hash, Array, Symbol].each do |klass|
  klass.class_eval do
    def present?
      !blank?
    end

    def blank?
      respond_to?(:empty?) ? !!empty? : !self
    end
  end
end
