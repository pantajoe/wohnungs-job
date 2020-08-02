class WohnungsJob
  extend IconHelper

  NOTIFICATION_TYPES = %i[standard email]
  ERROR_ICON = icon_path("failure")
  RECIPIENTS = ENV["EMAIL_RECIPIENTS"].split(",").map(&:strip)
  SERVICES = %i[wg_gesucht immoscout24 nadann immowelt wohnungen_ms studenten_wg]
  SERVICE_VARIABLES = %i[@wg_gesucht @immoscout24 @nadann @immowelt @wohnungen_ms @studenten_wg]
  INFO =
    {
      :@wg_gesucht => {
        url: "https://www.wg-gesucht.de/wohnungen-in-Muenster.91.2.1.0.html?csrf_token=36037b68fb108af8b70cf623581392244af66633&offer_filter=1&noDeact=1&city_id=91&category=2&rent_type=2",
        container: %w[#main_content.row #main_column .panel.panel-default:not(.panel-hidden) .panel-body .row .col-sm-8 .list-details-panel-inner .detailansicht],
        translation: "WG Gesucht",
        color: :blue,
        icon: icon_path("wg_gesucht"),
        button_color: "#FFA500",
        button_hover_color: "#E59502",
      },
      :@immoscout24 => {
        url: "https://www.immobilienscout24.de/Suche/S-2/Wohnung-Miete/Umkreissuche/M_fcnster/-/-160749/2448287/-/1276010036/3/2,00-/52,00-/EURO--890,00",
        container: %w[#resultListItems .result-list__listing .result-list-entry__brand-title-container h5],
        translation: "ImmoScout24",
        color: :magenta,
        icon: icon_path("immoscout24"),
        button_color: "#FF8C00",
        button_hover_color: "#E27D02",
      },
      :@nadann => {
        url: "https://www.nadann.de/rubriken/kleinanzeigen/biete-wohnen/",
        container: %w[#c10 section .row .col-xs-12 .card-columns .card .card-block .card-text span],
        translation: "NaDann",
        color: :green,
        icon: icon_path("nadann"),
        button_color: "#006400",
        button_hover_color: "#005600",
      },
      :@immowelt => {
        url: "https://www.immowelt.de/liste/muenster/wohnungen/mieten?lat=51.95256&lon=7.63143&sr=3&roomi=2&rooma=4&prima=900&wflmi=52&sort=createdate%20desc",
        container: %w[.immoliste .content_wrapper .iw_content .list_background_wrapper.padding_top_none_s .iw_list_content .js-object.listitem_wrap .listitem.clear .listcontent.clear h2.ellipsis],
        translation: "Immowelt",
        color: :yellow,
        icon: icon_path("immowelt"),
        button_color: "#FFFF00",
        button_hover_color: "#D8D800",
      },
      :@wohnungen_ms => {
        url: "https://wohnungen.ms/provisionsfreie-immobilien-muenster/wohnungen-angebote/",
        container: %w[#content article.post header h3],
        translation: "Wohnungen MS",
        color: :red,
        icon: icon_path("wohnungen_ms"),
        button_color: "#FF6347",
        button_hover_color: "#F44E30",
      },
      :@studenten_wg => {
        url: "https://www.studenten-wg.de/angebote_lesen.html?detailsuche=aus&preismode=&newsort=&stadt=M%FCnster&fuer=Wohnungen&mietart=1&mbsuche=Frauen+oder+M%E4nner&zimin=2&zimax=3",
        container: %w[.property-container .property-text h3],
        translation: "Studenten WG",
        color: :cyan,
        icon: icon_path("studenten_wg"),
        button_color: "#00FFFF",
        button_hover_color: "#01C6C6",
      },
    }

  attr_accessor(*(SERVICES + SERVICES.map { |s| :"#{s}_cache" }))

  def initialize(options = {})
    @notification_type = options[:notification_type]&.to_sym if NOTIFICATION_TYPES.include?(options[:notification_type]&.to_sym)
    @notification_type ||= :standard
  end

  def self.perform(options = {})
    WohnungsJob.new(options).perform
  end

  def perform
    loop do
      perform_task
      sleep(30)
    end
  end

  private

  def perform_task
    puts "###################################################"
    puts "###################################################"

    SERVICE_VARIABLES.each do |service|
      puts "###################################################"
      cache_service = :"#{service}_cache"

      begin
        response = HTTParty.get(INFO[service][:url])
      rescue Net::OpenTimeout, Errno::ETIMEDOUT, SocketError, Net::ReadTimeout, OpenSSL::SSL::SSLError, Errno::ECONNRESET, Errno::ECONNREFUSED
        next
      rescue StandardError => e
        case @notification_type
        when :standard
          notify_exit!
          puts "The script crashed with an error #{e.class}: #{e}".white.on_red
        when :email
          notify_email_with_error!(e)
          notify_exit!
          next
        else
          notify_exit!
          puts "The script crashed with an error #{e.class}: #{e}".white.on_red
        end
      end

      instance_variable_set cache_service, Nokogiri::HTML(response)

      INFO[service][:container].each do |selector|
        instance_variable_set cache_service, instance_variable_get(cache_service).css(selector)
      end

      instance_variable_set cache_service, instance_variable_get(cache_service).first&.text&.gsub(/\Aneu/i, "")

      next unless instance_variable_get(cache_service)

      notify(service) if instance_variable_get(cache_service) != instance_variable_get(service)

      instance_variable_set service, instance_variable_get(cache_service)
      instance_variable_set cache_service, nil

      puts(INFO[service][:translation].bold.public_send(INFO[service][:color]) + ": " + instance_variable_get(service).strip.gsub("\n", ""))
    end

    puts "###################################################"
    puts "###################################################"
    puts "###################################################"
    puts "\n"
  end

  def notify(service)
    return notify_with_email(service) if @notification_type == :email

    if OS.mac?
      TerminalNotifier::Guard.success(
        "Neue Wohnung auf #{INFO[service][:translation]}!",
        title: INFO[service][:translation],
        icon_path: INFO[service][:icon],
        open: INFO[service][:url],
      )
    elsif OS.linux?
      Libnotify.show(
        body: "Neue Wohnung auf #{INFO[service][:translation]}!",
        summary: INFO[service][:translation],
        timeout: 3,
        urgency: :normal,
        append: true,
        icon_path: INFO[service][:icon],
      )
    elsif OS.windows?
      BurntToastNotification.show(
        title: INFO[service][:translation],
        body: "Neue Wohnung auf #{INFO[service][:translation]}!",
        icon_path: INFO[service][:icon],
        onclick_url: INFO[service][:url],
      )
    end
  end

  def notify_with_email(service)
    RECIPIENTS.each do |recipient|
      EmailHelper.send_mail(
        recipient: recipient,
        subject: "Neue Wohnung auf #{INFO[service][:translation]}!",
        html_options: {
          url: INFO[service][:url],
          name: INFO[service][:translation],
          button_color: INFO[service][:button_color],
          button_hover_color: INFO[service][:button_hover_color],
        },
      )
    end
  end

  def notify_email_with_error!(error)
    EmailHelper.send_mail(
      recipient: RECIPIENTS.first,
      subject: "The Build Crashed!",
      html_options: {
        error: true,
        error_object: error,
      },
    )
  end

  def notify_exit!
    if OS.mac?
      TerminalNotifier::Guard.failed(
        "The script crashed! Restart it!",
        title: "SystemExit",
        icon_path: ERROR_ICON,
      )
    elsif OS.linux?
      Libnotify.show(
        body: "The script crashed! Restart it!",
        summary: "SystemExit",
        timeout: 3,
        urgency: :critical,
        append: true,
        icon_path: ERROR_ICON,
      )
    elsif OS.windows?
      BurntToastNotification.show(
        title: "SystemExit",
        body: "The script crashed! Restart it!",
        icon_path: ERROR_ICON,
      )
    end
  end
end
