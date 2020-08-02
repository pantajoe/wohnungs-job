require "uri"

class BurntToastNotification
  class AttributeMissingError < StandardError; end

  REQUIRED_ATTRIBUTES = %i[title]

  attr_accessor :title, :body, :icon_path, :onclick_url

  def initialize(options)
    @title = options[:title]
    @body = options[:body]
    @icon_path = options[:icon_path]
    @onclick_url = options[:onclick_url]
    @duration = %w[Short Long].include?(options[:duration]) ? options[:duration] : "Short"

    raise AttributeMissingError if required_attributes_missing?
    raise URI::InvalidURIError, "bad URI(is not URI?)" unless @onclick_url =~ URI::regexp
  end

  def self.show(options)
    burnt_toast = BurntToastNotification.new(options)
    burnt_toast.show
  end

  def show
    execute build_powershell_command
  end

  private

  def execute(command)
    command = Base64.strict_encode64(command.encode("utf-16le"))
    system "PowerShell -EncodedCommand #{command}"
  end

  def build_powershell_command
    command = "Import-Module BurntToast;\n"
    command += "$Text1 = New-BTText -Content '#{@title}';\n"
    command += "$Text2 = New-BTText -Content '#{@body}';\n" if @body.present?
    command += "$Image1 = New-BTImage -Source #{@icon_path} -AppLogoOverride;\n" if @icon_path.present?

    if @body.present?
      command += "$Binding1 = New-BTBinding -Children $Text1, $Text2"
    else
      command += "$Binding1 = New-BTBinding -Children $Text1"
    end

    if @icon_path.present?
      command += " -AppLogoOverride $Image1;\n"
    else
      command += ";\n"
    end

    if @onclick_url.present?
      command += "$Button1 = New-BTButton -Content 'Open #{@title}' -Arguments '#{@onclick_url}' -ActivationType Protocol;\n"
      command += "$Action1 = New-BTAction -Buttons $Button1;\n"
    end

    command += "$Visual1 = New-BTVisual -BindingGeneric $Binding1;\n"
    command += "$Content1 = New-BTContent -Visual $Visual1 -Duration '#{@duration}'"

    if @onclick_url.present?
      command += " -Launch '#{@onclick_url}' -ActivationType Protocol -Actions $Action1;\n"
    else
      command += ";\n"
    end

    command += "Submit-BTNotification -Content $Content1;"

    return command
  end

  def required_attributes_missing?
    REQUIRED_ATTRIBUTES.each do |attr|
      return true if self.public_send(attr).blank?
    end

    false
  end
end
