module TerminalNotifier
  module Guard
    OSX_BUILT_IN_SOUNDS = { :notify => 'Blow', :failed => 'Sosumi', :pending => 'Morse', :success => 'Hero' }.freeze

    def self.execute(verbose, options)
      if available? && installed?
        options.merge!({ :contentImage=> GUARD_ICON, :appIcon => icon(options.delete(:type)) })
        type = options.delete(:type)
        options.merge!({ :contentImage=> GUARD_ICON, :appIcon => icon(type), :sound => sound(type) })
        command = [bin_path, *options.map { |k,v| ["-#{k}", v.to_s] }.flatten]
        if RUBY_VERSION < '1.9'
          require 'shellwords'
          command = Shellwords.shelljoin(command)
        end
        result = ''
        IO.popen(command) do |stdout|
          output = stdout.read
          STDOUT.print output if verbose
          result << output
        end
        result
      else
        raise "terminal-notifier is only supported on Mac OS X 10.8, or higher." if !available?
        raise "TerminalNotifier not installed. Please do so by running `brew install terminal-notifier`" if !installed?
      end
    end

    def sound(type = :notify)
      type ||= :notify
      OSX_BUILT_IN_SOUNDS[type.to_sym]
    end
    module_function :sound
  end
end
