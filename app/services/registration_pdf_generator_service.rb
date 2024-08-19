require 'open-uri'
require "prawn"
require "prawn/measurement_extensions"
require 'fileutils'

class RegistrationPdfGeneratorService
  class WrongArgumentError < StandardError; end

  class << self
    def call(registration)
      new(registration).generate!
    end
  end

  def initialize(registration)
    @registration = registration
    @clients = registration.clients
    # @parent   = registration.parent
    # @children = registration.children
    set_pdf_values
  end

  def generate!
    pdf = Prawn::Document.new(document_options) do |pdf|
      draw(pdf)
    end
    # pdf.render_file("#{Rails.root}/public/inscriptions/inscription_#{@registration.id}.pdf")
    pdf.render
  end

  private

  def draw(pdf)
    @pdf = pdf
    # register_fonts
    # @pdf.font("Quicksand")
    @last_measured_y = pdf.cursor

    add_logo
    add_id

    pdf.move_down 10
    pdf.text "Fiche d'inscription #{Date.today.strftime('%d/%m/%Y')}", size: 20, style: :bold, align: :center
    pdf.move_down 50

    # GPT simple table
    # Table header
    headers = ["Nom", "Prénom", "Date de naissance", "Téléphone", "Email", "Réinscription", "Remarques"]
    data = [headers]

    # Table rows
    @clients.each do |client|
      data << [
        client.last_name,
        client.first_name,
        client.birthdate.try(:strftime, '%d/%m/%Y'),
        client.phone_1,
        client.mail,
        client.re_registration ? "Oui" : "",
        client.notes.empty? ? 'Aucune remarque' : client.notes
      ]
    end

    # Generate the table
    pdf.table(data, header: true, position: :center, width: pdf.bounds.width, cell_style: { size: 9 }) do
      row(0).background_color = 'DDDDDD'
    end
    # END GPT simple table

    pdf.move_down 40

    pdf.text "Pour valider votre inscription, cette fiche est à envoyer avec le règlement* :", size: 12, align: :left
    pdf.move_down 20
    pdf.text "- Au directeur de l'établissement Christophe REGIS : par sms, email ou courrier.", size: 12, align: :left
    pdf.move_down 5
    pdf.text "0680143454 / tccourcelles@gmail.com / 4 rue du cheval Moussé, 92000 Nanterre.", size: 12, align: :left
    pdf.move_down 10
    pdf.text "- Ou directement au Tennis Club de Courcelles : 211/229 rue de Courcelles, Paris 17ème.", size: 12, align: :left
    pdf.move_down 20
    pdf.text "*Règlement, encaissable uniquement après accord sur un créneau horaire, une assurance est systématiquement prise par le Club", size: 10, align: :left

  end

  def add_logo
    @pdf.image File.open(@logopath), width: 80, height: 80, at: [1.cm - @margin_left, 26.cm + @margin_top]
  end

  def add_id
    @pdf.text_box "id: #{@registration.id}", at: [@pdf.bounds.width - @margin_right, @margin_top]
  end

  # def register_fonts
  #   @pdf.font_families.update(
    #     "Quicksand" => {
  #       normal: "#{Rails.root}/app/assets/fonts/Quicksand-Regular.ttf",
  #       bold: "#{Rails.root}/app/assets/fonts/Quicksand-Bold.ttf",
  #       semibold: "#{Rails.root}/app/assets/fonts/Quicksand-SemiBold.ttf",
  #       italic: "#{Rails.root}/app/assets/fonts/Quicksand-Italic.ttf",
  #       light: "#{Rails.root}/app/assets/fonts/Quicksand-Light.ttf"
  #     },
  #     "Helvetica" => {
    #       normal: "#{Rails.root}/app/assets/fonts/Helvetica-Regular.ttf",
  #       bold: "#{Rails.root}/app/assets/fonts/Helvetica-Bold.ttf",
  #       italic: "#{Rails.root}/app/assets/fonts/Helvetica-Italic.ttf"
  #     }
  #   )
  # end

  def write_text(text, options = {})
    @pdf.text text, options
    @pdf.move_down(options[:move_down]) if options[:move_down]
  end


  def set_pdf_values
    @layout           = :portrait
    @page_size        = 'A4'
    @margin_left      = 15.mm
    @margin_right     = 15.mm
    @margin_top       = 20.mm
    @margin_bottom    = 5.mm
    @logopath         = "#{Rails.root}/app/assets/images/TCC_logo.png"
    @initial_y        = 50
    @initialmove_y    = 50
  end

  def document_options
    {
      page_layout: @layout,
      left_margin: @margin_left,
      right_margin:@margin_right,
      top_margin: @margin_top,
      bottom_margin: @margin_bottom,
      page_size: @page_size
    }
  end

  # def paint
  #   @pdf.canvas do
  #     @pdf.fill_color "DEC8B3"
  #     @pdf.fill_polygon [@pdf.bounds.left, @pdf.bounds.top], [@pdf.bounds.left + 9.cm, @pdf.bounds.top], [@pdf.bounds.left, @pdf.bounds.top - 9.cm]
  #   end
  #   reset_color
  # end

  # def reset_color
  #   @pdf.fill_color '000000'
  # end

  # def print_header_and_footer
  #   @pdf.page_count.times do |i|
  #     string = "#{@registration.pdf_name} - #{@parent.full_name} - #{@nanny.full_name} - #{i+1}/#{@pdf.page_count}"
  #     @pdf.go_to_page i+1
  #     @pdf.draw_text string, at: [ 7.mm - @margin_left, -3.mm], size: 6, style: :light
  #     next if i == 0

  #     @pdf.draw_text string, at: [ 7.mm - @margin_left, 282.mm], size: 6, style: :light
  #   end

  # reset_color
  # end

  def title_options
    {
      size: 24,
      align: :right,
      style: :semibold,
      move_down: 10
    }
  end

  def subtitle_options
    {
      size: 18,
      align: :right,
      style: :light,
      move_down: 10
    }
  end

  def section_title_options
    {
      size: 11,
      align: :left,
      style: :semibold,
      move_down: 10
    }
  end

  def text_options
    {
      size: 8,
      align: :left,
      style: :light,
      move_down: 4
    }
  end
end
