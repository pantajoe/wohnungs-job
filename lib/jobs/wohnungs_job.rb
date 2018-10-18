require 'pry-byebug'
require_relative '../modules/os'
if OS.mac?
  require 'terminal-notifier'
  require 'terminal-notifier-guard'
  require_relative '../initializers/terminal_notifier_guard'
elsif OS.linux?
  require 'libnotify'
elsif OS.windows?
  require 'pycall/import'
end
require 'httparty'
require 'nokogiri'

class WohnungsJob
  extend PyCall::Import
  pyfrom :'win10toast', import: 'ToastNotifier'

  SERVICES = %i[wg_gesucht immoscout24 nadann immowelt wohnungen_ms studenten_wg]
  SERVICE_VARIABLES = %i[@wg_gesucht @immoscout24 @nadann @immowelt @wohnungen_ms @studenten_wg]
  INFO =
    {
      :@wg_gesucht => {
        url: 'https://www.wg-gesucht.de/wohnungen-in-Muenster.91.2.1.0.html?csrf_token=36037b68fb108af8b70cf623581392244af66633&offer_filter=1&noDeact=1&city_id=91&category=2&rent_type=2',
        container: %w[#main_content.row #main_column .panel.panel-default:not(.panel-hidden) .panel-body .row .col-sm-8 .list-details-panel-inner .detailansicht],
        translation: 'WG Gesucht',
      },
      :@immoscout24 => {
        url: 'https://www.immobilienscout24.de/Suche/S-2/Wohnung-Miete/Umkreissuche/M_fcnster/-/-160749/2448287/-/1276010036/3/2,00-/40,00-/EURO--820,00',
        container: %w[#resultListItems .result-list__listing .result-list-entry__brand-title-container h5],
        translation: 'ImmoScout24',
      },
      :@nadann => {
        url: 'https://www.nadann.de/rubriken/kleinanzeigen/biete-wohnen/',
        container: %w[#c10 section .row .col-xs-12 .card-columns .card .card-block .card-text span],
        translation: 'NaDann',
      },
      :@immowelt => {
        url: 'https://www.immowelt.de/liste/muenster/wohnungen/mieten?lat=51.95256&lon=7.63143&sr=3&roomi=2&rooma=3&prima=900&wflmi=40&sort=createdate%2Bdesc',
        container: %w[.immoliste .content_wrapper .iw_content .list_background_wrapper.padding_top_none_s .iw_list_content .js-object.listitem_wrap .listitem.clear .listcontent.clear h2.ellipsis],
        translation: 'Immowelt',
      },
      :@wohnungen_ms => {
        url: 'https://wohnungen.ms/provisionsfreie-immobilien-muenster/wohnungen-angebote/',
        container: %w[#content article.post header h3],
        translation: 'Wohnungen MS',
      },
      :@studenten_wg => {
        url: 'https://www.studenten-wg.de/angebote_lesen.html?detailsuche=aus&preismode=&newsort=&stadt=M%FCnster&fuer=Wohnungen&mietart=1&mbsuche=Frauen+oder+M%E4nner&zimin=2&zimax=3',
        container: %w[.property-container .property-text h3],
        translation: 'Studenten WG',
      },
    }

  attr_accessor(*(SERVICES + SERVICES.map {|s| :"#{s}_cache" }))

  def self.perform
    loop do
      perform_task
      sleep(30)
    end
  end

  def self.perform_task
    SERVICE_VARIABLES.each do |var|
      puts '###################################################'
      puts '###################################################'
      puts '###################################################'
      cache_var = :"#{var}_cache"

      begin
        response = HTTParty.get(INFO[var][:url])
      rescue Net::OpenTimeout, Errno::ETIMEDOUT, SocketError
        next
      end

      instance_variable_set cache_var, Nokogiri::HTML(response)

      INFO[var][:container].each do |selector|
        instance_variable_set cache_var, instance_variable_get(cache_var).css(selector)
      end

      instance_variable_set cache_var, instance_variable_get(cache_var).first.text.gsub(/\Aneu/i, '')

      notify(var) if instance_variable_get(cache_var) != instance_variable_get(var)

      instance_variable_set var, instance_variable_get(cache_var)
      instance_variable_set cache_var, nil

      puts(INFO[var][:translation] + ": " + instance_variable_get(var).strip.gsub("\n", ''))
    end
    puts '###################################################'
    puts '###################################################'
    puts '###################################################'
    puts "\n"
  end

  def self.notify(service)
    if OS.mac?
      TerminalNotifier::Guard.success("Neue Wohnung auf #{INFO[service][:translation]}")
    elsif OS.linux?
      Libnotify.show(
        body: "Neue Wohnung",
        summary: INFO[service][:translation],
        timeout: 3,
        urgency: :normal,
        append: true,
      )
    elsif OS.windows?
      ToastNotifier.new.show_toast(
        INFO[service][:translation],
        "Neue Wohnung auf #{INFO[service][:translation]}!",
        icon_path: nil,
        duration: 3
      )
    end
  end
end
